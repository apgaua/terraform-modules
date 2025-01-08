resource "aws_subnet" "dbsubnets" {
  count             = length(var.databasesubnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.databasesubnets[count.index].cidr
  availability_zone = var.databasesubnets[count.index].availability_zone

  tags = {
    Name = var.databasesubnets[count.index].name
  }
}