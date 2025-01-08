resource "aws_eip" "vpc_eip" {
  count  = length(var.availability_zones)
  domain = "vpc"
  tags = {
    Name = format("%s-eip-%s", var.project_name, count.index)
  }
}

resource "aws_nat_gateway" "natgw" {
  count         = length(var.availability_zones)
  allocation_id = aws_eip.vpc_eip[count.index].id
  subnet_id     = aws_subnet.publicsubnets[count.index].id

  tags = {
    Name = format("%s-nat-gateway-%s", var.project_name, count.index)
  }
  depends_on = [aws_internet_gateway.gw,
    aws_eip.vpc_eip,
  aws_subnet.publicsubnets]
}

resource "aws_subnet" "privatesubnets" {
  count             = length(var.privatesubnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.privatesubnets[count.index].cidr
  availability_zone = var.privatesubnets[count.index].availability_zone

  tags = {
    Name = var.privatesubnets[count.index].name
  }
}

#Route Table
resource "aws_route_table" "private_internet_access" {
  count  = length(var.privatesubnets)
  vpc_id = aws_vpc.main.id
  tags = {
    Name = format("%s-private-%s", var.project_name, count.index)
  }
}

#Route
resource "aws_route" "private_access" {
  count                  = length(var.privatesubnets)
  route_table_id         = aws_route_table.private_internet_access[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.natgw[count.index].id
}

#Route table association
resource "aws_route_table_association" "private" {
  count          = length(var.privatesubnets)
  subnet_id      = aws_subnet.privatesubnets[count.index].id
  route_table_id = aws_route_table.private_internet_access[count.index].id
  depends_on     = [aws_subnet.privatesubnets]
}