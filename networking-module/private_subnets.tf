##################################################
##################### SUBNET #####################
##################################################

resource "aws_subnet" "privatesubnets" {
  count             = length(var.privatesubnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.privatesubnets[count.index]
  availability_zone = data.aws_availability_zones.azones.names[count.index]
  tags = merge(
    {
      name = format("%s-private-%s", var.project_name, data.aws_availability_zones.azones.names[count.index])
    },
    var.default_tags
  )
  depends_on = [aws_vpc_ipv4_cidr_block_association.main]
}

resource "aws_subnet" "podsubnets" {
  count             = length(var.podsubnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.podsubnets[count.index]
  availability_zone = data.aws_availability_zones.azones.names[count.index]
  tags = merge(
    {
      name = format("%s-pod-%s", var.project_name, data.aws_availability_zones.azones.names[count.index])
    },
    var.default_tags
  )
  depends_on = [aws_vpc_ipv4_cidr_block_association.main]
}

##################################################
################### ROUTE TABLE ##################
##################################################

resource "aws_route_table" "private_internet_access" {
  count  = length(var.privatesubnets)
  vpc_id = aws_vpc.main.id
  tags = merge(
    {
      name = format("private-%s", var.project_name)
    },
    var.default_tags
  )
}

resource "aws_route_table" "pod_internet_access" {
  count  = length(var.podsubnets)
  vpc_id = aws_vpc.main.id
  tags = merge(
    {
      name = format("pod-%s", var.project_name)
    },
    var.default_tags
  )
}

##################################################
###################### ROUTE #####################
##################################################

resource "aws_route" "private_access" {
  count                  = length(var.privatesubnets)
  route_table_id         = aws_route_table.private_internet_access[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = var.singlenat == true ? aws_nat_gateway.main[0].id : aws_nat_gateway.main[
    index(
      var.publicsubnets[*].availability_zone,
      var.privatesubnets[count.index].availability_zone
    )
  ].id
}

resource "aws_route" "pod_access" {
  count                  = length(var.podsubnets)
  route_table_id         = aws_route_table.pod_internet_access[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = var.singlenat == true ? aws_nat_gateway.main[0].id : aws_nat_gateway.main[
    index(
      var.publicsubnets[*].availability_zone,
      var.podsubnets[count.index].availability_zone
    )
  ].id
}

##################################################
########### ROUTE TABLE ASSOCIATION ##############
##################################################

resource "aws_route_table_association" "private" {
  count          = length(var.privatesubnets)
  subnet_id      = aws_subnet.privatesubnets[count.index].id
  route_table_id = aws_route_table.private_internet_access[count.index].id
  depends_on     = [aws_subnet.privatesubnets]
}

resource "aws_route_table_association" "pod" {
  count          = length(var.podsubnets)
  subnet_id      = aws_subnet.podsubnets[count.index].id
  route_table_id = aws_route_table.pod_internet_access[count.index].id
  depends_on     = [aws_subnet.podsubnets]
}