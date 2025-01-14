resource "aws_ssm_parameter" "lb_arn" {
  name  = "/ECS/loadbalancer/id"
  value = aws_lb.main.arn
  type  = "String"
}

resource "aws_ssm_parameter" "lb_listener" {
  name  = "/ECS/loadbalancer/listener"
  value = aws_lb_listener.main.arn
  type  = "String"
}