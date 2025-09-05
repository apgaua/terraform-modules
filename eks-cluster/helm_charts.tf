resource "helm_release" "main" {
  count      = length(var.helm_charts)
  name       = var.helm_charts[count.index].name
  repository = var.helm_charts[count.index].repository
  chart      = var.helm_charts[count.index].chart
  namespace  = var.helm_charts[count.index].namespace
  wait       = var.helm_charts[count.index].wait
  version    = var.helm_charts[count.index].version
  set        = var.helm_charts[count.index].set

  depends_on = [aws_eks_cluster.main, aws_eks_node_group.main]
}

resource "helm_release" "cluster_autoscaler" {
  name  = "aws-cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart = "cluster-autoscaler"
  namespace        = "kube-system"
  create_namespace = true

  set = [{
    name  = "replicaCount"
    value = 1
  },
  {
    name  = "awsRegion"
    value = var.region
  },
  {
    name  = "rbac.serviceAccount.create"
    value = true
  },
  {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.autoscaler.arn
  },
  {
    name  = "autoscalingGroups[0].name"
    value = aws_eks_node_group.main[0].resources[0].autoscaling_groups[0].name
  },
  {
    name  = "autoscalingGroups[0].maxSize"
    value = aws_eks_node_group.main[0].scaling_config[0].max_size
  },
  {
    name  = "autoscalingGroups[0].minSize"
    value = aws_eks_node_group.main[0].scaling_config[0].min_size
  }
  ]

  depends_on = [aws_eks_cluster.main, aws_eks_node_group.main]
}