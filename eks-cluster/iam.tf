################################################################################
################################## CLUSTER #####################################
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
############################# CLUSTER AUTOSCALER ###############################
################################################################################

data "aws_iam_policy_document" "autoscaler" {
  statement {
    actions = ["sts:AssumeRolewithWebIdentity"]
    effect  = "Allow"
    principals {
      type = "Federated"
      identifiers = [ aws_iam_openid_connect_provider.eks.arn ]
    }
  }
}

resource "aws_iam_role" "eks_autoscaler_role" {
  name               = format("%s-autoscaler-role", var.project_name)
  assume_role_policy = data.aws_iam_policy_document.autoscaler.json
  tags = merge(
    {
    Name = "${var.project_name}-eks-autoscaler"
  },
  var.default_tags)
}

data "aws_iam_policy_document" "autoscaler_policy" {
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
  name        = format("%s-autoscaler-policy", var.project_name)
  description = "IAM policy for EKS Cluster Autoscaler"
  policy      = data.aws_iam_policy_document.autoscaler_policy.json
  tags = merge(
    {
    Name = "${var.project_name}-eks-autoscaler"
  },
  var.default_tags)
}

resource "aws_iam_role_policy_attachment" "autoscaler" {
  role       = aws_iam_role.autoscaler.name
  policy_arn = aws_iam_policy.autoscaler.arn
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