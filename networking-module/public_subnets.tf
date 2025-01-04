resource "aws_subnet" "public" {
  for_each          = var.publicsubnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  tags = {
    Name = "${each.key}"
  }