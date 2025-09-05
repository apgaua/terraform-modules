resource "aws_eks_node_group" "main" {
  count           = length(var.nodes)
  cluster_name    = aws_eks_cluster.main.id
  node_group_name = var.nodes[count.index].node_group_name
  node_role_arn   = aws_iam_role.eks_nodes_role.arn
  instance_types  = var.nodes[count.index].instance_types
  subnet_ids      = data.aws_ssm_parameter.pod_subnets[*].value

  scaling_config {
    desired_size = var.nodes[count.index].auto_scale_options[0].desired
    max_size     = var.nodes[count.index].auto_scale_options[0].max
    min_size     = var.nodes[count.index].auto_scale_options[0].min
  }

  capacity_type = "ON_DEMAND" # or SPOT

  labels = var.nodes[count.index].labels

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