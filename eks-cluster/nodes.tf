resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.id
  node_group_name = aws_eks_cluster.main.id
  node_role_arn   = aws_iam_role.eks_nodes_role.arn
  instance_types  = var.node_instance_type
  subnet_ids      = data.aws_ssm_parameter.pod_subnets[*].value

  scaling_config {
    desired_size = lookup(var.auto_scale_options, "desired")
    max_size     = lookup(var.auto_scale_options, "max")
    min_size     = lookup(var.auto_scale_options, "min")
  }

  labels = {
    "ingress/ready" = "true"
  }

  lifecycle {
    ignore_changes = [
      scaling_config[0].desired_size,
    ]
  }
  tags = merge({ "kubernetes.io/cluster/${var.project_name}" = "shared" }, var.default_tags)

  depends_on = [
    #kubernetes_config_map.aws_auth
    aws_eks_access_entry.nodes
  ]

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}