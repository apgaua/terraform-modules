resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = format("%s-igw", var.project_name)
  }
}

resource "aws_subnet" "publicsubnets" {
  count             = length(var.publicsubnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.publicsubnets[count.index].cidr
  availability_zone = var.publicsubnets[count.index].availability_zone
  tags = {
    Name = var.publicsubnets[count.index].name
  }
}
resource "aws_route_table" "public_internet_access" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = format("%s-public", var.project_name)
  }
}

resource "aws_route" "public_access" {
  route_table_id         = aws_route_table.public_internet_access.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "public_" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.publicsubnets[count.index].id
  route_table_id = aws_route_table.public_internet_access.id
}
