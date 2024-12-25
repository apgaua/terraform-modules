resource "aws_subnet" "main" {
  count             = length(var.cidr_blocks)
  vpc_id            = var.vpc_id
  cidr_block        = element(var.cidr_blocks, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = var.subnets[count.index].name
  }

#   depends_on = [
#     module.vpc.aws_vpc_ipv4_cidr_block_association
#   ]
}