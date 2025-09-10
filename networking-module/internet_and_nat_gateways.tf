##################################################
################### ELASTIC IP ###################
##################################################

resource "aws_eip" "eip" {
  count  = var.singlenat == true ? 1 : length(var.publicsubnets)
  domain = "vpc"

  tags = merge({ Name = format("eip-%s", var.project_name) }, var.default_tags)
}

##################################################
############### INTERNET GATEWAY #################
##################################################

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge({ Name = format("%s-igw", var.project_name) }, var.default_tags)
}

##################################################
################# NAT GATEWAY ####################
##################################################

resource "aws_nat_gateway" "main" {
  count         = var.singlenat == true ? 1 : length(var.publicsubnets)
  allocation_id = aws_eip.eip[count.index].id
  subnet_id     = aws_subnet.publicsubnets[count.index].id

  tags       = merge({ Name = format("%s-nat-gateway-%s", var.project_name, count.index) }, var.default_tags)
  depends_on = [aws_internet_gateway.gw, aws_eip.eip, aws_subnet.publicsubnets]
}

##################################################
################# NAT INSTANCE ###################
##################################################

