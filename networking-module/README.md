<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_network_acl.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl_association.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_association) | resource |
| [aws_network_acl_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_route.pod_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.private_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.pod_internet_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.private_internet_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public_internet_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.pod](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_ssm_parameter.databasesubnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.podsubnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.privatesubnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.publicsubnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_subnet.dbsubnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.podsubnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.privatesubnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.publicsubnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_ipv4_cidr_block_association.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipv4_cidr_block_association) | resource |
| [aws_availability_zones.azones](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_database_nacl_rules"></a> [database\_nacl\_rules](#input\_database\_nacl\_rules) | ACL Rules to DB Subnet | <pre>list(object({<br/>    rule_start_number = number<br/>    rule_action       = string<br/>    protocol          = string<br/>    from_port         = optional(number)<br/>    to_port           = optional(number)<br/>  }))</pre> | `[]` | no |
| <a name="input_databasesubnets"></a> [databasesubnets](#input\_databasesubnets) | Database CIDR | `list(string)` | `[]` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | n/a | `map(string)` | <pre>{<br/>  "contato": "",<br/>  "dia": "",<br/>  "repo": ""<br/>}</pre> | no |
| <a name="input_podsubnets"></a> [podsubnets](#input\_podsubnets) | POD subnet CIDR | `list(string)` | `[]` | no |
| <a name="input_privatesubnets"></a> [privatesubnets](#input\_privatesubnets) | Private subnet CIDR | `list(string)` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | VPC Variables | `string` | n/a | yes |
| <a name="input_publicsubnets"></a> [publicsubnets](#input\_publicsubnets) | Public subnet CIDR | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region | `string` | n/a | yes |
| <a name="input_singlenat"></a> [singlenat](#input\_singlenat) | n/a | `bool` | `true` | no |
| <a name="input_vpc_additional_cidrs"></a> [vpc\_additional\_cidrs](#input\_vpc\_additional\_cidrs) | CIDRs adicionais | `list(string)` | <pre>[<br/>  ""<br/>]</pre> | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR principal | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ssm_database_subnets"></a> [ssm\_database\_subnets](#output\_ssm\_database\_subnets) | SSM Parameters about database subnets id |
| <a name="output_ssm_pod_subnets"></a> [ssm\_pod\_subnets](#output\_ssm\_pod\_subnets) | SSM Parameters about POD subnets id |
| <a name="output_ssm_private_subnets"></a> [ssm\_private\_subnets](#output\_ssm\_private\_subnets) | SSM Parameters about private subnets id |
| <a name="output_ssm_public_subnets"></a> [ssm\_public\_subnets](#output\_ssm\_public\_subnets) | SSM Parameters about public subnets id |
| <a name="output_ssm_vpc_id"></a> [ssm\_vpc\_id](#output\_ssm\_vpc\_id) | n/a |
<!-- END_TF_DOCS -->