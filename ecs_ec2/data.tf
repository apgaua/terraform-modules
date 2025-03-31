data "aws_ssm_parameter" "vpc" {
  name = var.ssm_vpc_id
}

data "aws_vpc" "main" {
  id = data.aws_ssm_parameter.vpc.value
}

data "aws_ssm_parameter" "public_subnet" {
  count = length(var.publicsubnets)
  name  = var.publicsubnets[count.index]
}

data "aws_ssm_parameter" "private_subnet" {
  count = length(var.privatesubnets)
  name  = var.privatesubnets[count.index]
}
