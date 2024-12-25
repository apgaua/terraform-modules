resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.project_name
  }
}

output "vpc_id" {
  value = aws_vpc.main.id
}

resource "aws_ssm_parameter" "vpc" {
  name  = "/${var.project_name}/vpc/id"
  type  = "String"
  value = aws_vpc.main.id
}