resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.project_name
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "main" {
  count      = length(var.vpc_additional_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.vpc_additional_cidrs[count.index]
}

resource "aws_ssm_parameter" "vpc" {
  name  = "/${var.project_name}/vpc/id"
  type  = "String"
  value = aws_vpc.main.id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_additional_cidrs" {
  value = aws_vpc_ipv4_cidr_block_association.main.id
}