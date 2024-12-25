resource "aws_subnet" "main" {
#   count             = length(var.database_subnets)
  vpc_id            = var.vpc_id
  cidr_block        = var.subnets.cidr
  availability_zone = var.subnets.availability_zone

  tags = {
    Name = var.subnets.name
  }

#   depends_on = [
#     module.vpc.aws_vpc_ipv4_cidr_block_association
#   ]
}