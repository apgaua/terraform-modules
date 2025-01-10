#LB Security group
resource "aws_security_group" "lb" {
  name   = format("%s-load-balancer", var.project_name)
  vpc_id = data.aws_ssm_parameter.vpc.value

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  dynamic "ingress" {
    for_each = local.lb_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Libera trafego na porta ${ingress.value}"
    }
  }
}



## Main security group
resource "aws_security_group" "main" {
  name   = format("%s-load-balancer-sg", var.project_name)
  vpc_id = data.aws_ssm_parameter.vpc.value

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  dynamic "ingress" {
    for_each = local.ecs_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "-1"
      cidr_blocks = [data.aws_vpc.main.cidr_block]
      description = "Libera trafego para vpc"

    }

  }
}
