# 11 - Container Instances

Deploys a single-container Azure Container Instances (ACI) group with a
public IP and DNS name label, running the sample `aci-helloworld` image by
default.

## Architecture

![Contoso Ltd. sample architecture — Container Instances](../../docs/diagrams/11-container-instances.svg)

## Resources created

- `azurerm_resource_group`
- `random_string` (uniqueness suffix)
- `azurerm_container_group` (Linux, public IP, DNS name label)

## Required inputs

| Name | Description | Default |
|------|-------------|---------|
| `name_prefix` | Prefix for resource names (random suffix appended to DNS label) | `iacaci` |
| `location` | Azure region | `eastus` |
| `image` | Container image | `mcr.microsoft.com/azuredocs/aci-helloworld:latest` |
| `cpu` | CPU cores | `1` |
| `memory` | Memory (GB) | `1.5` |
| `tags` | Resource tags | see `variables.tf` |

No inputs are required beyond the defaults; this module deploys standalone.

## Usage

```bash
cd terraform/11-container-instances
terraform init
terraform apply -var-file=terraform.tfvars.example
```
