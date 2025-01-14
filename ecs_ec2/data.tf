data "aws_vpc" "main" {
  tags = {
    "Name" = "ecs-vpc"
  }
}
data "aws_ssm_parameter" "vpc" {
  name = var.ssm_vpc_id
}

data "aws_ssm_parameter" "pubsubnet" {
  count = length(var.publicsubnets)
  name = var.publicsubnets[*]
}

data "aws_ssm_parameter" "privsubnet" {
  count = length(var.privatesubnets)
  name = var.privatesubnets[*]
}
