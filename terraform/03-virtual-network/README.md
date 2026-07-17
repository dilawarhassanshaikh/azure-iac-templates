# 03 - Virtual Network

Deploys a hub-style virtual network with three subnets (`web`, `app`,
`data`), each with its own network security group and sane default rules
(web allows 80/443, app allows 8080 from the web subnet, data allows
1433/5432 from the app subnet; all deny remaining inbound traffic).

## Architecture

![Contoso Ltd. sample architecture — Virtual Network](../../docs/diagrams/03-virtual-network.svg)

## Resources created

- `azurerm_resource_group`
- `azurerm_virtual_network`
- `azurerm_subnet` x3 (`web` 10.0.1.0/24, `app` 10.0.2.0/24, `data` 10.0.3.0/24)
- `azurerm_network_security_group` x3 + associations

## Required inputs

| Name | Description | Default |
|------|-------------|---------|
| `name_prefix` | Prefix for resource names | `corenet` |
| `location` | Azure region | `eastus` |
| `address_space` | VNet address space | `["10.0.0.0/16"]` |
| `tags` | Resource tags | see `variables.tf` |

No inputs are required beyond the defaults; this module deploys standalone.

## Usage

```bash
cd terraform/03-virtual-network
terraform init
terraform apply -var-file=terraform.tfvars.example
```
