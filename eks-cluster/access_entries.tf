resource "aws_eks_access_entry" "nodes" {
  count         = length(var.cluster) > 0 && var.cluster[0].eks_mode != "FULLFARGATE" ? 1 : 0
  cluster_name  = aws_eks_cluster.main.id
  principal_arn = aws_iam_role.eks_nodes_role[0].arn
  type          = "EC2_LINUX"
}

resource "aws_eks_access_entry" "fargate" {
  count         = length(var.cluster) > 0 && var.cluster[0].eks_mode != "NODEGROUPS" ? 1 : 0
  cluster_name  = aws_eks_cluster.main.id
  principal_arn = aws_iam_role.fargate_cluster_role[0].arn
  type          = "FARGATE_LINUX"
}