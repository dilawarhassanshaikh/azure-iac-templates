#!/usr/bin/env python3
"""Generates simple layered architecture-diagram SVGs for the catalog,
using 'Contoso Ltd.' as the sample tenant. One SVG per service, output
to docs/diagrams/<NN>-<slug>.svg.
"""
import os
import xml.dom.minidom as minidom

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
OUT_DIR = os.path.join(SCRIPT_DIR, "..", "docs", "diagrams")

BOX_W = 210
BOX_H = 64
COL_GAP = 28
ROW_GAP = 64
PAD = 40
TITLE_H = 70
SUBTITLE_H = 26

CATEGORY_STYLE = {
    "ext":     dict(fill="#f3f4f6", stroke="#6b7280", text="#374151", dash="6,4"),
    "net":     dict(fill="#dbeafe", stroke="#2563eb", text="#1e3a8a", dash=None),
    "compute": dict(fill="#dcfce7", stroke="#16a34a", text="#14532d", dash=None),
    "data":    dict(fill="#fef3c7", stroke="#d97706", text="#78350f", dash=None),
    "sec":     dict(fill="#fee2e2", stroke="#dc2626", text="#7f1d1d", dash=None),
    "mgmt":    dict(fill="#ede9fe", stroke="#7c3aed", text="#4c1d95", dash=None),
}


def esc(s):
    return (
        s.replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
    )


def wrap_text(text, max_chars):
    words = text.split(" ")
    lines, cur = [], ""
    for w in words:
        trial = (cur + " " + w).strip()
        if len(trial) > max_chars and cur:
            lines.append(cur)
            cur = w
        else:
            cur = trial
    if cur:
        lines.append(cur)
    return lines


def estimate_text_width(text, font_size, bold=False):
    # Rough average glyph-width heuristic for Segoe UI/Helvetica/Arial,
    # with a safety margin so text never overflows the canvas.
    factor = 0.62 if bold else 0.56
    return len(text) * font_size * factor


def render(slug, title, rg_name, layers, filename):
    n_layers = len(layers)
    max_cols = max(len(layer) for layer in layers)
    grid_w = max_cols * BOX_W + (max_cols - 1) * COL_GAP + 2 * PAD

    subtitle_text = (
        f"Contoso Ltd. sample tenant • Resource Group: {rg_name}"
    )
    title_w = estimate_text_width(title, 20, bold=True) + 2 * PAD
    subtitle_w = estimate_text_width(subtitle_text, 13, bold=False) + 2 * PAD

    canvas_w = max(grid_w, title_w, subtitle_w)
    canvas_h = (
        TITLE_H
        + SUBTITLE_H
        + n_layers * BOX_H
        + (n_layers - 1) * ROW_GAP
        + 2 * PAD
    )

    svg_parts = []
    svg_parts.append(
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{canvas_w}" '
        f'height="{canvas_h}" viewBox="0 0 {canvas_w} {canvas_h}" '
        f'font-family="Segoe UI, Helvetica, Arial, sans-serif">'
    )
    svg_parts.append(f'<rect width="{canvas_w}" height="{canvas_h}" fill="#ffffff"/>')
    svg_parts.append(
        '<defs><marker id="arrow" viewBox="0 0 10 10" refX="9" refY="5" '
        'markerWidth="7" markerHeight="7" orient="auto-start-reverse">'
        '<path d="M0,0 L10,5 L0,10 z" fill="#475569"/></marker></defs>'
    )

    # Title + subtitle
    svg_parts.append(
        f'<text x="{canvas_w/2}" y="{PAD+8}" text-anchor="middle" '
        f'font-size="20" font-weight="700" fill="#111827">{esc(title)}</text>'
    )
    svg_parts.append(
        f'<text x="{canvas_w/2}" y="{PAD+30}" text-anchor="middle" '
        f'font-size="13" fill="#6b7280">{esc(subtitle_text)}</text>'
    )

    top_y = PAD + TITLE_H
    layer_positions = []  # list of list of (x, y, w, h, cx, cy)

    for row, layer in enumerate(layers):
        n = len(layer)
        row_w = n * BOX_W + (n - 1) * COL_GAP
        start_x = (canvas_w - row_w) / 2
        y = top_y + row * (BOX_H + ROW_GAP)
        positions = []
        for col, node in enumerate(layer):
            x = start_x + col * (BOX_W + COL_GAP)
            positions.append((x, y, BOX_W, BOX_H, x + BOX_W / 2, y + BOX_H / 2))
        layer_positions.append(positions)

    # Arrows between consecutive layers
    for row in range(n_layers - 1):
        a = layer_positions[row]
        b = layer_positions[row + 1]
        pairs = []
        if len(a) == 1:
            pairs = [(a[0], bb) for bb in b]
        elif len(b) == 1:
            pairs = [(aa, b[0]) for aa in a]
        elif len(a) == len(b):
            pairs = list(zip(a, b))
        else:
            pairs = [(aa, bb) for aa in a for bb in b]

        for (ax, ay, aw, ah, acx, acy), (bx, by, bw, bh, bcx, bcy) in pairs:
            y1 = ay + ah
            y2 = by
            svg_parts.append(
                f'<line x1="{acx:.1f}" y1="{y1:.1f}" x2="{bcx:.1f}" y2="{y2:.1f}" '
                f'stroke="#475569" stroke-width="1.6" marker-end="url(#arrow)"/>'
            )

    # Boxes
    for row, layer in enumerate(layers):
        for col, node in enumerate(layer):
            top_label, bottom_label, category = node
            x, y, w, h, cx, cy = layer_positions[row][col]
            style = CATEGORY_STYLE[category]
            dash_attr = f' stroke-dasharray="{style["dash"]}"' if style["dash"] else ""
            rx = 10
            svg_parts.append(
                f'<rect x="{x:.1f}" y="{y:.1f}" width="{w}" height="{h}" rx="{rx}" '
                f'fill="{style["fill"]}" stroke="{style["stroke"]}" stroke-width="1.6"{dash_attr}/>'
            )
            top_lines = wrap_text(top_label, 26)
            bottom_lines = wrap_text(bottom_label, 30) if bottom_label else []
            total_lines = len(top_lines) + len(bottom_lines)
            line_h = 15
            start_ty = cy - (total_lines - 1) * line_h / 2 - (4 if bottom_lines else 0)
            ty = start_ty
            for i, line in enumerate(top_lines):
                svg_parts.append(
                    f'<text x="{cx:.1f}" y="{ty:.1f}" text-anchor="middle" '
                    f'font-size="13.5" font-weight="600" fill="{style["text"]}">{esc(line)}</text>'
                )
                ty += line_h
            if bottom_lines:
                ty += 3
                for line in bottom_lines:
                    svg_parts.append(
                        f'<text x="{cx:.1f}" y="{ty:.1f}" text-anchor="middle" '
                        f'font-size="11.5" font-family="Consolas, Menlo, monospace" '
                        f'fill="{style["text"]}">{esc(line)}</text>'
                    )
                    ty += line_h

    svg_parts.append("</svg>")
    svg = "".join(svg_parts)

    # Validate well-formed XML
    minidom.parseString(svg)

    path = os.path.join(OUT_DIR, filename)
    with open(path, "w", encoding="utf-8") as f:
        f.write(svg)
    return path


DIAGRAMS = [
    dict(
        slug="01-linux-virtual-machine",
        title="Linux Virtual Machine",
        rg="rg-contoso-linux-vm",
        layers=[
            [("Internet", "", "ext")],
            [("Public IP", "pip-contoso-linux", "net")],
            [("Network Security Group", "nsg-contoso-linux (allow 22)", "net")],
            [("Virtual Network / Subnet", "vnet-contoso (10.0.0.0/16)", "net")],
            [("Network Interface", "nic-contoso-linux", "net")],
            [("Linux Virtual Machine", "vm-contoso-linux (Ubuntu 22.04)", "compute")],
        ],
    ),
    dict(
        slug="02-windows-virtual-machine",
        title="Windows Virtual Machine",
        rg="rg-contoso-win-vm",
        layers=[
            [("Internet", "", "ext")],
            [("Public IP", "pip-contoso-win", "net")],
            [("Network Security Group", "nsg-contoso-win (allow 3389)", "net")],
            [("Virtual Network / Subnet", "vnet-contoso (10.0.0.0/16)", "net")],
            [("Network Interface", "nic-contoso-win", "net")],
            [("Windows Virtual Machine", "vm-contoso-win (Server 2022)", "compute")],
        ],
    ),
    dict(
        slug="03-virtual-network",
        title="Virtual Network",
        rg="rg-contoso-network",
        layers=[
            [("Virtual Network", "vnet-contoso (10.0.0.0/16)", "net")],
            [
                ("Subnet: web", "snet-web-contoso (10.0.1.0/24)", "net"),
                ("Subnet: app", "snet-app-contoso (10.0.2.0/24)", "net"),
                ("Subnet: data", "snet-data-contoso (10.0.3.0/24)", "net"),
            ],
            [
                ("NSG: web", "nsg-web-contoso", "net"),
                ("NSG: app", "nsg-app-contoso", "net"),
                ("NSG: data", "nsg-data-contoso", "net"),
            ],
        ],
    ),
    dict(
        slug="04-storage-account",
        title="Storage Account",
        rg="rg-contoso-storage",
        layers=[
            [("Client Application", "", "ext")],
            [("Storage Account", "stcontosoxxxx (StorageV2)", "data")],
            [("Blob Container", "contoso-data", "data")],
        ],
    ),
    dict(
        slug="05-app-service-webapp",
        title="App Service Web App",
        rg="rg-contoso-webapp",
        layers=[
            [("Internet", "", "ext")],
            [("App Service Plan", "asp-contoso (Linux, B1)", "compute")],
            [("Linux Web App", "app-contoso.azurewebsites.net", "compute")],
        ],
    ),
    dict(
        slug="06-azure-functions",
        title="Azure Functions",
        rg="rg-contoso-functions",
        layers=[
            [("HTTP / Event Trigger", "", "ext")],
            [("Function App", "func-contoso (Consumption Y1)", "compute")],
            [
                ("Storage Account", "stcontosofunc", "data"),
                ("Application Insights", "appi-contoso", "mgmt"),
            ],
        ],
    ),
    dict(
        slug="07-sql-database",
        title="Azure SQL Database",
        rg="rg-contoso-sql",
        layers=[
            [("Client Application", "", "ext")],
            [("SQL Server", "sql-contoso.database.windows.net", "data")],
            [("SQL Database", "sqldb-contoso (Basic)", "data")],
        ],
    ),
    dict(
        slug="08-postgresql-flexible-server",
        title="PostgreSQL Flexible Server",
        rg="rg-contoso-postgres",
        layers=[
            [("Client Application", "", "ext")],
            [("PostgreSQL Flexible Server", "psql-contoso (v16)", "data")],
            [("Database", "contosodb", "data")],
        ],
    ),
    dict(
        slug="09-aks-cluster",
        title="Azure Kubernetes Service",
        rg="rg-contoso-aks",
        layers=[
            [("Internet", "", "ext")],
            [("AKS Cluster", "aks-contoso", "compute")],
            [("Default Node Pool", "Standard_DS2_v2 x2", "compute")],
            [("Contoso Workloads", "pods / services", "compute")],
        ],
    ),
    dict(
        slug="10-container-registry",
        title="Azure Container Registry",
        rg="rg-contoso-acr",
        layers=[
            [("CI/CD Pipeline", "", "ext")],
            [("Container Registry", "acrcontoso.azurecr.io (Standard)", "mgmt")],
            [("Container Images", "contoso-app:latest", "mgmt")],
        ],
    ),
    dict(
        slug="11-container-instances",
        title="Azure Container Instances",
        rg="rg-contoso-aci",
        layers=[
            [("Internet", "", "ext")],
            [("Public IP + DNS Label", "contoso-aci.eastus.azurecontainer.io", "net")],
            [("Container Group", "aci-contoso", "compute")],
            [("Container", "contoso-app (1 vCPU / 1.5 GB)", "compute")],
        ],
    ),
    dict(
        slug="12-key-vault",
        title="Azure Key Vault",
        rg="rg-contoso-kv",
        layers=[
            [("App / User (RBAC)", "", "ext")],
            [("Key Vault", "kv-contoso (RBAC authorization)", "sec")],
            [("Secrets / Keys / Certificates", "", "sec")],
        ],
    ),
    dict(
        slug="13-cosmos-db",
        title="Azure Cosmos DB",
        rg="rg-contoso-cosmos",
        layers=[
            [("Client Application", "", "ext")],
            [("Cosmos DB Account", "cosmos-contoso (SQL API)", "data")],
            [("SQL Database", "contosodb", "data")],
            [("Container", "contoso-items", "data")],
        ],
    ),
    dict(
        slug="14-redis-cache",
        title="Azure Cache for Redis",
        rg="rg-contoso-redis",
        layers=[
            [("Client Application", "", "ext")],
            [("Azure Cache for Redis", "redis-contoso.redis.cache.windows.net", "data")],
        ],
    ),
    dict(
        slug="15-load-balancer",
        title="Standard Load Balancer",
        rg="rg-contoso-lb",
        layers=[
            [("Internet", "", "ext")],
            [("Public IP", "pip-contoso-lb", "net")],
            [("Load Balancer", "lb-contoso (Standard)", "net")],
            [
                ("Backend VM 1", "vm-contoso-01", "compute"),
                ("Backend VM 2", "vm-contoso-02", "compute"),
            ],
        ],
    ),
    dict(
        slug="16-application-gateway",
        title="Application Gateway (WAF)",
        rg="rg-contoso-agw",
        layers=[
            [("Internet", "", "ext")],
            [("Public IP", "pip-contoso-agw", "net")],
            [("Application Gateway", "agw-contoso (WAF_v2)", "net")],
            [("Dedicated Subnet", "snet-appgw-contoso", "net")],
            [("Backend Pool", "contoso-app-servers", "compute")],
        ],
    ),
    dict(
        slug="17-vm-scale-set",
        title="Virtual Machine Scale Set",
        rg="rg-contoso-vmss",
        layers=[
            [("Internet", "", "ext")],
            [("Load Balancer + Public IP", "lb-contoso-vmss", "net")],
            [("Virtual Machine Scale Set", "vmss-contoso (2+ instances)", "compute")],
            [
                ("Instance 0", "contoso-vmss_0", "compute"),
                ("Instance 1", "contoso-vmss_1", "compute"),
            ],
        ],
    ),
    dict(
        slug="18-service-bus",
        title="Service Bus Queue",
        rg="rg-contoso-servicebus",
        layers=[
            [("Publisher App", "", "ext")],
            [("Service Bus Namespace", "sb-contoso (Standard)", "mgmt")],
            [("Queue", "contoso-orders", "mgmt")],
            [("Consumer App", "", "ext")],
        ],
    ),
    dict(
        slug="19-log-analytics-workspace",
        title="Log Analytics + App Insights",
        rg="rg-contoso-monitor",
        layers=[
            [("Contoso Azure Resources", "", "ext")],
            [("Log Analytics Workspace", "log-contoso (PerGB2018)", "mgmt")],
            [("Application Insights", "appi-contoso", "mgmt")],
            [("Dashboards / Alerts", "", "mgmt")],
        ],
    ),
    dict(
        slug="20-cdn-front-door",
        title="Azure Front Door",
        rg="rg-contoso-frontdoor",
        layers=[
            [("Internet / Users", "", "ext")],
            [("Front Door Endpoint", "fd-contoso.azurefd.net", "net")],
            [("Origin Group", "contoso-origin-group", "net")],
            [("Origin", "contoso-app (App Service / Storage)", "compute")],
        ],
    ),
]


def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    for spec in DIAGRAMS:
        filename = f"{spec['slug']}.svg"
        path = render(
            slug=spec["slug"],
            title=f"Contoso Ltd. — {spec['title']}",
            rg_name=spec["rg"],
            layers=spec["layers"],
            filename=filename,
        )
        print(f"wrote {path}")


if __name__ == "__main__":
    main()
