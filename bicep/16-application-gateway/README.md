# Application Gateway (Bicep)

Deploys a WAF_v2 Application Gateway with autoscaling, its own virtual
network and subnet, a Standard static public IP, a placeholder backend pool,
an HTTP listener, and a basic routing rule.

## Architecture

![Contoso Ltd. sample architecture — Application Gateway](../../docs/diagrams/16-application-gateway.svg)

## Resources

- `Microsoft.Network/virtualNetworks` - dedicated VNet for the gateway subnet
- `Microsoft.Network/publicIPAddresses` - Standard, static
- `Microsoft.Network/applicationGateways` - WAF_v2, autoscale 1-3 instances

## Required inputs

| Parameter | Description | Default |
|---|---|---|
| `namePrefix` | Prefix for resource names | `agw` |
| `skuName` | Gateway SKU/tier | `WAF_v2` |
| `autoscaleMinCapacity` | Minimum autoscale instances | `1` |
| `autoscaleMaxCapacity` | Maximum autoscale instances | `3` |
| `backendIpAddresses` | Placeholder backend pool IP addresses - replace with real targets | `["10.30.2.4", "10.30.2.5"]` |
| `location` | Azure region | resource group location |
| `tags` | Tags applied to all resources | `{ environment: 'dev', project: 'azure-iac-templates' }` |

## Deploy

```bash
az group create --name <rg-name> --location eastus
az deployment group create --resource-group <rg-name> --template-file main.bicep --parameters main.parameters.json
```

> Note: this module always configures the Web Application Firewall (OWASP
> 3.2, Prevention mode), which requires a WAF-capable SKU. If you change
> `skuName` to a non-WAF SKU (e.g. `Standard_v2`), remove the
> `webApplicationFirewallConfiguration` block from `main.bicep` first.
