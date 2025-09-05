resource "aws_eks_node_group" "main" {
  count           = length(var.nodegroup)
  cluster_name    = aws_eks_cluster.main.id
  node_group_name = format("%s-%s", aws_eks_cluster.main.id, var.nodegroup[count.index].name_suffix)
  node_role_arn   = aws_iam_role.eks_nodes_role.arn
  ami_type = var.nodegroup[count.index].ami_type
  instance_types  = var.nodegroup[count.index].instance_types
  subnet_ids      = data.aws_ssm_parameter.pod_subnets[*].value

  scaling_config {
    desired_size = var.nodegroup[count.index].auto_scale_options[0].desired
    max_size     = var.nodegroup[count.index].auto_scale_options[0].max
    min_size     = var.nodegroup[count.index].auto_scale_options[0].min
  }

  capacity_type = var.nodegroup[count.index].capacity_type

  labels = var.nodegroup[count.index].labels

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