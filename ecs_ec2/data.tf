data "aws_vpc" "main" {
  tags = {
    "Name" = "ecs-vpc"
  }
}
data "aws_ssm_parameter" "vpc" {
  name = var.ssm_vpc_id
}

data "aws_ssm_parameter" "pubsubnet" {
  count = var.publicsubnets
  name.publicsubnets[count.index]
}

data "aws_ssm_parameter" "privsubnet" {
  count = var.privatesubnets
  name = var.privatesubnets[count.index]
}
