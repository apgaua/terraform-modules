resource "aws_eks_cluster" "main" {
  name     = var.project_name
  version  = var.kubernetes_version
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids              = data.aws_ssm_parameter.private_subnets[*].value
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = aws_kms_key.main.arn
    }
  }

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  zonal_shift_config {
    enabled = var.zonal_shift
  }

  upgrade_policy {
    support_type = var.upgrade_policy_support_type
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_service_policy,
    aws_iam_role_policy_attachment.ecr,
    aws_iam_role_policy_attachment.ssm
  ]

  tags = merge({ "kubernetes.io/cluster/${var.project_name}" = "shared" }, var.default_tags)
}