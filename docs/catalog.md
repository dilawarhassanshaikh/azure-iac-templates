# Catalog & Conventions

This document is the single source of truth for the 20 deployments in this
repository and the conventions every module (Terraform, Bicep, ARM) follows.

## The 20 deployments

| # | Slug | Azure service |
|---|------|----------------|
| 01 | `linux-virtual-machine` | Linux Virtual Machine (Ubuntu) + NIC, public IP, NSG |
| 02 | `windows-virtual-machine` | Windows Server Virtual Machine + NIC, public IP, NSG |
| 03 | `virtual-network` | Virtual Network with multiple subnets + NSG associations |
| 04 | `storage-account` | Storage Account (blob/file/table/queue), secure defaults |
| 05 | `app-service-webapp` | App Service Plan + Linux Web App |
| 06 | `azure-functions` | Function App (Consumption plan) + Storage + App Insights |
| 07 | `sql-database` | Azure SQL logical server + database |
| 08 | `postgresql-flexible-server` | Azure Database for PostgreSQL Flexible Server |
| 09 | `aks-cluster` | Azure Kubernetes Service (AKS) cluster |
| 10 | `container-registry` | Azure Container Registry (ACR) |
| 11 | `container-instances` | Azure Container Instances (ACI) container group |
| 12 | `key-vault` | Azure Key Vault (RBAC authorization) |
| 13 | `cosmos-db` | Azure Cosmos DB account (SQL API) |
| 14 | `redis-cache` | Azure Cache for Redis |
| 15 | `load-balancer` | Standard public Load Balancer |
| 16 | `application-gateway` | Application Gateway v2 with WAF |
| 17 | `vm-scale-set` | Linux Virtual Machine Scale Set |
| 18 | `service-bus` | Service Bus namespace + queue |
| 19 | `log-analytics-workspace` | Log Analytics Workspace + Application Insights |
| 20 | `cdn-front-door` | Azure Front Door (Standard) |

Each service lives at:

```
terraform/<NN>-<slug>/
bicep/<NN>-<slug>/
arm/<NN>-<slug>/
```

## Conventions

### Architecture diagrams
- Every service has a sample architecture diagram at
  `docs/diagrams/<NN>-<slug>.svg`, generated from
  `scripts/gen_diagrams.py`-style layered SVGs (kept simple and
  dependency-free so they render natively on GitHub).
- Diagrams use a fictional **Contoso Ltd.** tenant for all example naming
  (e.g. `vm-contoso-linux`, `rg-contoso-sql`, `fd-contoso.azurefd.net`) —
  they illustrate resource topology only, not a real deployment.
- Each of the three module READMEs (Terraform/Bicep/ARM) for a service
  embeds the same diagram via `## Architecture` near the top, referenced
  as `../../docs/diagrams/<NN>-<slug>.svg`.

### General
- All resource names are parameterized with a `name_prefix` (Terraform) /
  `namePrefix` (Bicep/ARM) input, combined with `resourceToken`/random
  suffixes where global uniqueness is required (storage accounts, ACR,
  Key Vault, SQL server, Cosmos DB, etc).
- Every module exposes a `location` input (default `eastus`) and a `tags`
  input (default includes `environment` and `project`).
- No secrets are hardcoded. Passwords/keys are always sensitive
  input parameters with no default, or SSH public key auth is used instead.
- Every module has a `README.md` with a description, a resource list, the
  required inputs, and the exact deploy command(s).

### Terraform (`terraform/`)
- Self-contained root modules: each `terraform apply` creates its own
  resource group plus the resources for that service.
- Provider: `hashicorp/azurerm`, `~> 4.0`, `required_version >= 1.9`.
- Files per module: `main.tf`, `variables.tf`, `outputs.tf`,
  `terraform.tfvars.example`, `README.md`.
- Formatted with `terraform fmt`.

### Bicep (`bicep/`)
- Resource-group scoped (`targetScope = 'resourceGroup'`), matching the
  ARM templates. The user creates the resource group first
  (`az group create`), then deploys with `az deployment group create`.
- Files per module: `main.bicep`, `main.parameters.json`, `README.md`.

### ARM (`arm/`)
- Resource-group scoped, classic `azuredeploy.json` +
  `azuredeploy.parameters.json` pair, schema
  `https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#`.
- Files per module: `azuredeploy.json`, `azuredeploy.parameters.json`,
  `README.md`.
- Must be valid JSON (no comments, no trailing commas).

### Deploy command patterns

Terraform:
```bash
cd terraform/<NN>-<slug>
terraform init
terraform apply -var-file=terraform.tfvars.example
```

Bicep:
```bash
az group create --name <rg-name> --location eastus
az deployment group create \
  --resource-group <rg-name> \
  --template-file bicep/<NN>-<slug>/main.bicep \
  --parameters bicep/<NN>-<slug>/main.parameters.json
```

ARM:
```bash
az group create --name <rg-name> --location eastus
az deployment group create \
  --resource-group <rg-name> \
  --template-file arm/<NN>-<slug>/azuredeploy.json \
  --parameters arm/<NN>-<slug>/azuredeploy.parameters.json
```
