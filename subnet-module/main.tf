resource "aws_subnet" "main" {
  count             = length(var.cidr_block)
  vpc_id            = var.vpc_id
  cidr_block        = element(var.cidr_block, count.index)
  availability_zone = element(var.availability_zone, count.index)

  tags = {
    Name = var.subnets[count.index].name
  }

#   depends_on = [
#     module.vpc.aws_vpc_ipv4_cidr_block_association
#   ]
}