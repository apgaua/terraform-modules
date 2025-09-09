resource "helm_release" "main" {
  count      = length(var.helm_charts)
  name       = var.helm_charts[count.index].name
  repository = var.helm_charts[count.index].repository
  chart      = var.helm_charts[count.index].chart
  namespace  = var.helm_charts[count.index].namespace
  wait       = var.helm_charts[count.index].wait
  version    = var.helm_charts[count.index].version
  set        = var.helm_charts[count.index].set

depends_on = aws_eks_cluster.mail
}

resource "helm_release" "cluster_autoscaler" {
  count = var.cluster[0].enable_cluster_autoscaler ? 1 : 0
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
    value = aws_iam_role.autoscaler[0].arn
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
depends_on = aws_eks_cluster.main
}

resource "helm_release" "node_termination_handler" {
  name      = "aws-node-termination-handler"
  namespace = "kube-system"

  chart      = "aws-node-termination-handler"
  repository = "https://aws.github.io/eks-charts/"

  set = [
    {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.node_termination.arn
  },
  {
    name  = "awsRegion"
    value = var.region
  },
  {
    name  = "queueURL"
    value = aws_sqs_queue.node_termination.url
  },
  {
    name  = "enableSqsTerminationDraining"
    value = true
  },
  {
    name  = "enableSpotInterruptionDraining"
    value = true
  },
  {
    name  = "enableRebalanceMonitoring"
    value = true
  },
  {
    name  = "enableRebalanceDraining"
    value = true
  },
  {
    name  = "enableScheduledEventDraining"
    value = true
  },
  {
    name  = "deleteSqsMsgIfNodeNotFound"
    value = true
  },
  {
    name  = "checkTagBeforeDraining"
    value = false
  }
  ]
}