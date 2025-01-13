output "ssm_vpc_id" {
  value = aws_ssm_parameter.vpc.id
}

output "vpc_additional_cidrs" {
  value = [for i in aws_vpc_ipv4_cidr_block_association.main : i.id]
}

output "ssm_public_subnets" {
  value       = aws_ssm_parameter.publicsubnets[*].id
  description = "SSM Parameters about public subnets id"
}

output "ssm_private_subnets" {
  value       = aws_ssm_parameter.privatesubnets[*].id
  description = "SSM Parameters about private subnets id"
}

output "ssm_database_subnets" {
  value       = aws_ssm_parameter.databasesubnets[*].id
  description = "SSM Parameters about database subnets id"
}