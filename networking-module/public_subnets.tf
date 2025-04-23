##################################################
##################### SUBNET #####################
##################################################

resource "aws_subnet" "publicsubnets" {
  count             = length(var.publicsubnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.publicsubnets[count.index]
  availability_zone = data.aws_availability_zones.azones.names[count.index]
  tags = merge(
    {
      name = format("public-%s-%s", var.project_name, data.aws_availability_zones.azones.names[count.index])
    },
    var.default_tags
  )
}

##################################################
################### ROUTE TABLE ##################
##################################################

resource "aws_route_table" "public_internet_access" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    {
      name = format("public-%s", var.project_name)
    },
    var.default_tags
  )
}

##################################################
###################### ROUTE #####################
##################################################

resource "aws_route" "public_access" {
  route_table_id         = aws_route_table.public_internet_access.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

##################################################
########### ROUTE TABLE ASSOCIATION ##############
##################################################

resource "aws_route_table_association" "public" {
  count          = length(var.publicsubnets)
  subnet_id      = aws_subnet.publicsubnets[count.index].id
  route_table_id = aws_route_table.public_internet_access.id
}
