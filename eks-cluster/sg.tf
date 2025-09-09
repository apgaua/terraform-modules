resource "aws_security_group_rule" "nodeports" {
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
  from_port         = 30000
  to_port           = 32767
  protocol          = "tcp"
  description       = "Allow NodePort Services"
  security_group_id = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

resource "aws_security_group_rule" "coredns_udp" {
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  description       = "CoreDNS"
  security_group_id = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

resource "aws_security_group_rule" "coredns_tcp" {
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
  from_port         = 53
  to_port           = 53
  protocol          = "tcp"
  description       = "CoreDNS TCP"
  security_group_id = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

resource "aws_security_group_rule" "port_8443" {
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
  from_port         = 8443
  to_port           = 8443
  protocol          = "tcp"
  description       = "Admission Controller"
  security_group_id = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}