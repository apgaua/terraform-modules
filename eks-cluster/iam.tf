################################################################################
################################## EKS CLUSTER #################################
################################################################################


data "aws_iam_policy_document" "cluster" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name               = format("%s-cluster-role", var.project_name)
  assume_role_policy = data.aws_iam_policy_document.cluster.json
  tags = {
    Name = "${var.project_name}-eks-cluster"
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

################################################################################
############################### EKS FARGATE PROFILE ############################
################################################################################

data "aws_iam_policy_document" "fargate"{
  count = length(var.cluster) > 0 && var.cluster[0].enable_fargate ? 1 : 0
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks-fargate-pods.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "fargate_cluster_role" {
  count = length(var.cluster) > 0 && var.cluster[0].enable_fargate ? 1 : 0
  name               = format("%s-fargate-role", var.project_name)
  assume_role_policy = data.aws_iam_policy_document.fargate[count.index].json
  tags = {
    Name = "${var.project_name}-fargate-cluster"
  }
}

resource "aws_iam_role_policy_attachment" "fargate" {
  count = length(var.cluster) > 0 && var.cluster[0].enable_fargate ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.fargate_cluster_role[count.index].name
}


################################################################################
############################# CLUSTER AUTOSCALER ###############################
################################################################################

data "aws_iam_policy_document" "autoscaler" {
count = length(var.cluster) > 0 && var.cluster[0].enable_cluster_autoscaler ? 1 : 0
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    principals {
      type = "Federated"
      identifiers = [ aws_iam_openid_connect_provider.eks.arn ]
    }
  }
}

resource "aws_iam_role" "autoscaler" {
count = length(var.cluster) > 0 && var.cluster[0].enable_cluster_autoscaler ? 1 : 0
  name               = format("%s-autoscaler-role", var.project_name)
  assume_role_policy = data.aws_iam_policy_document.autoscaler[0].json
  tags = merge(
    {
    Name = "${var.project_name}-eks-autoscaler"
  },
  var.default_tags)
}

data "aws_iam_policy_document" "autoscaler_policy" {
count = length(var.cluster) > 0 && var.cluster[0].enable_cluster_autoscaler ? 1 : 0
  version = "2012-10-17"

  statement {

    effect = "Allow"
    actions = [
      "autoscaling-plans:DescribeScalingPlans",
      "autoscaling-plans:GetScalingPlanResourceForecastData",
      "autoscaling-plans:DescribeScalingPlanResources",
      "autoscaling:DescribeAutoScalingNotificationTypes",
      "autoscaling:DescribeLifecycleHookTypes",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeTerminationPolicyTypes",
      "autoscaling:DescribeScalingProcessTypes",
      "autoscaling:DescribePolicies",
      "autoscaling:DescribeTags",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeMetricCollectionTypes",
      "autoscaling:DescribeLoadBalancers",
      "autoscaling:DescribeLifecycleHooks",
      "autoscaling:DescribeAdjustmentTypes",
      "autoscaling:DescribeScalingActivities",
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAccountLimits",
      "autoscaling:DescribeScheduledActions",
      "autoscaling:DescribeLoadBalancerTargetGroups",
      "autoscaling:DescribeNotificationConfigurations",
      "autoscaling:DescribeInstanceRefreshes",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeLaunchTemplateVersions"
    ]

    resources = [
      "*"
    ]

  }
}

resource "aws_iam_policy" "autoscaler" {
  count      = var.cluster[0].enable_cluster_autoscaler ? 1 : 0
  name        = format("%s-autoscaler-policy", var.project_name)
  description = "IAM policy for EKS Cluster Autoscaler"
  policy      = data.aws_iam_policy_document.autoscaler_policy[0].json
  tags = merge(
    {
    Name = "${var.project_name}-eks-autoscaler"
  },
  var.default_tags)
}

resource "aws_iam_role_policy_attachment" "autoscaler" {
  count     = var.cluster[0].enable_cluster_autoscaler ? 1 : 0
  role       = aws_iam_role.autoscaler[0].name
  policy_arn = aws_iam_policy.autoscaler[0].arn
} 

################################################################################
######################### NODE TERMINATION HANDLER #############################
################################################################################

data "aws_iam_policy_document" "node_termination" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values = [
        "system:serviceaccount:kube-system:aws-node-termination-handler"
      ]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "node_termination" {
  assume_role_policy = data.aws_iam_policy_document.node_termination.json
  name               = format("%s-node-termination-handler", var.project_name)
}

data "aws_iam_policy_document" "aws_node_termination_handler_policy" {
  version = "2012-10-17"

  statement {

    effect = "Allow"
    actions = [
      "autoscaling:CompleteLifecycleAction",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeTags",
      "ec2:DescribeInstances",
      "sqs:DeleteMessage",
      "sqs:ReceiveMessage"
    ]

    resources = [
      "*"
    ]

  }
}

resource "aws_iam_policy" "aws_node_termination_handler_policy" {
  name        = format("%s-_node_termination_handler", var.project_name)
  path        = "/"
  description = var.project_name

  policy = data.aws_iam_policy_document.aws_node_termination_handler_policy.json
}

resource "aws_iam_policy_attachment" "aws_node_termination_handler_policy" {

  name = "aws_node_termination_handler"
  roles = [
    aws_iam_role.node_termination.name
  ]

  policy_arn = aws_iam_policy.aws_node_termination_handler_policy.arn
}

################################################################################
################################## NODES #######################################
################################################################################

data "aws_iam_policy_document" "nodes" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_nodes_role" {
  name               = format("%s-nodes-role", var.project_name)
  assume_role_policy = data.aws_iam_policy_document.nodes.json
  tags = {
    Name = "${var.project_name}-eks-nodes"
  }
}

resource "aws_iam_role_policy_attachment" "cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "nodes" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "ecr" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "ssm" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.eks_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.eks_nodes_role.name
}

resource "aws_iam_instance_profile" "eks_nodes_profile" {
  name = format("%s-eks-nodes-profile", var.project_name)
  role = aws_iam_role.eks_nodes_role.name
}