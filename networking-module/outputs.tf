output "ssm_vpc_id" {
  value = aws_ssm_parameter.vpc.id
  description = "VPC ID of deployed resources"
}

output "ssm_public_subnets" {
  value       = aws_ssm_parameter.publicsubnets[*].id
  description = "Public Networks IDs"
}

output "ssm_private_subnets" {
  value       = aws_ssm_parameter.privatesubnets[*].id
  description = "Private Networks IDs"
}

output "ssm_pod_subnets" {
  value       = aws_ssm_parameter.podsubnets[*].id
  description = "POD Networks IDs"
}

output "ssm_database_subnets" {
  value       = aws_ssm_parameter.databasesubnets[*].id
  description = "Database Networks IDs"
}