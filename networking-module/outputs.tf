output "ssm_vpc_id" {
  value = aws_ssm_parameter.vpc.id
}

output "ssm_vpc_additional_cidrs" {
 value = aws_ssm_parameter.vpc_additional_cidrs[*].value
}

output "ssm_public_subnets" {
  value       = aws_ssm_parameter.publicsubnets[*].id
  description = "SSM Parameters about public subnets id"
}

output "ssm_private_subnets" {
  value       = aws_ssm_parameter.privatesubnets[*].id
  description = "SSM Parameters about private subnets id"
}

output "ssm_pod_subnets" {
  value       = aws_ssm_parameter.podsubnets[*].id
  description = "SSM Parameters about POD subnets id"
}

output "ssm_database_subnets" {
  value       = aws_ssm_parameter.databasesubnets[*].id
  description = "SSM Parameters about database subnets id"
}