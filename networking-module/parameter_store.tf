resource "aws_ssm_parameter" "vpc" {
  name  = "/${var.project_name}/vpc/id"
  type  = "String"
  value = aws_vpc.main.id
}


resource "aws_ssm_parameter" "publicsubnets" {
  count = length(aws_subnet.publicsubnets)
  name  = "/${var.project_name}/subnets/public/${var.publicsubnets[count.index].availability_zone}/${var.publicsubnets[count.index].name}"
  type  = "String"
  value = aws_subnet.publicsubnets[count.index].id
  tags = {
      Name = "/${var.project_name}/subnets/public/${var.publicsubnets[count.index].availability_zone}/${var.publicsubnets[count.index].name}"
    }
}

resource "aws_ssm_parameter" "privatesubnets" {
  count = length(aws_subnet.privatesubnets)

  name  = "/${var.project_name}/subnets/private/${var.privatesubnets[count.index].availability_zone}/${var.privatesubnets[count.index].name}"
  type  = "String"
  value = aws_subnet.privatesubnets[count.index].id
  tags = {
      Name = "/${var.project_name}/subnets/private/${var.privatesubnets[count.index].availability_zone}/${var.privatesubnets[count.index].name}"
    }
}

resource "aws_ssm_parameter" "databasesubnets" {
  count = length(aws_subnet.dbsubnets)
  name  = "/${var.project_name}/subnets/databases/${var.databasesubnets[count.index].availability_zone}/${var.databasesubnets[count.index].name}"
  type  = "String"
  value = aws_subnet.dbsubnets[count.index].id
  tags = {
      Name = "/${var.project_name}/subnets/databases/${var.databasesubnets[count.index].availability_zone}/${var.databasesubnets[count.index].name}"
}
}