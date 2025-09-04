resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge({ Name = var.project_name }, var.default_tags)
}

resource "aws_vpc_ipv4_cidr_block_association" "main" {
  count = length(var.vpc_additional_cidrs)

  vpc_id     = aws_vpc.main.id
  cidr_block = var.vpc_additional_cidrs[count.index] # Attention to IPv4 CIDR block association restrictions: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-cidr-blocks.html
}