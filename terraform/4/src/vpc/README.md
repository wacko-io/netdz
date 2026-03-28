## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.12.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [yandex_vpc_network.network](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_network) | resource |
| [yandex_vpc_subnet.subnet](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_cidr"></a> [default\_cidr](#input\_default\_cidr) | Default CIDR block for subnet | `list(string)` | n/a | yes |
| <a name="input_default_zone"></a> [default\_zone](#input\_default\_zone) | Default zone for resources | `string` | n/a | yes |
| <a name="input_env_name"></a> [env\_name](#input\_env\_name) | Name of the environment | `string` | `"undefined"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_cidr"></a> [vpc\_cidr](#output\_vpc\_cidr) | n/a |
| <a name="output_vpc_network_id"></a> [vpc\_network\_id](#output\_vpc\_network\_id) | n/a |
| <a name="output_vpc_subnet"></a> [vpc\_subnet](#output\_vpc\_subnet) | n/a |
| <a name="output_vpc_zone"></a> [vpc\_zone](#output\_vpc\_zone) | n/a |
