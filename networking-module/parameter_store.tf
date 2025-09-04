resource "aws_ssm_parameter" "vpc" {
  name  = "/${var.project_name}/vpc/id"
  type  = "String"
  value = aws_vpc.main.id

  tags = merge({ Name = format("%s/vpc/id", var.project_name) }, var.default_tags)
}

resource "aws_ssm_parameter" "vpc_additional_cidrs" {
  count = length(var.vpc_additional_cidrs)
  name  = format("/%s/vpc/additional_cidrs/%s", var.project_name, count.index)
  type  = "String"
  value = aws_vpc_ipv4_cidr_block_association.main[count.index].id

  tags = merge({ Name = format("%s/vpc/additional_cidrs/%s", var.project_name, count.index) }, var.default_tags)
}

resource "aws_ssm_parameter" "publicsubnets" {
  count = length(aws_subnet.publicsubnets)
  name  = format("/%s/subnets/public/%s", var.project_name, replace(aws_subnet.publicsubnets[count.index].availability_zone, "-", "_"))
  type  = "String"
  value = aws_subnet.publicsubnets[count.index].id

  tags = merge({ Name = format("%s/subnets/public/%s", var.project_name, aws_subnet.publicsubnets[count.index].availability_zone) }, var.default_tags)
}

resource "aws_ssm_parameter" "privatesubnets" {
  count = length(aws_subnet.privatesubnets)

  name  = format("/%s/subnets/private/%s", var.project_name, replace(aws_subnet.privatesubnets[count.index].availability_zone, "-", "_"))
  type  = "String"
  value = aws_subnet.privatesubnets[count.index].id

  tags = merge({ Name = format("%s/subnets/private/%s", var.project_name, aws_subnet.privatesubnets[count.index].availability_zone) }, var.default_tags)
}

resource "aws_ssm_parameter" "podsubnets" {
  count = length(aws_subnet.podsubnets)

  name  = format("/%s/subnets/pod/%s", var.project_name, replace(aws_subnet.podsubnets[count.index].availability_zone, "-", "_"))
  type  = "String"
  value = aws_subnet.podsubnets[count.index].id

  tags = merge({ Name = format("%s/subnets/POD/%s", var.project_name, aws_subnet.podsubnets[count.index].availability_zone) }, var.default_tags)
}

resource "aws_ssm_parameter" "databasesubnets" {
  count = length(aws_subnet.dbsubnets)
  name  = format("/%s/subnets/databases/%s", var.project_name, replace(aws_subnet.dbsubnets[count.index].availability_zone, "-", "_"))
  type  = "String"
  value = aws_subnet.dbsubnets[count.index].id

  tags = merge({ Name = format("%s/subnets/database/%s", var.project_name, aws_subnet.dbsubnets[count.index].availability_zone) }, var.default_tags)
}