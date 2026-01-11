locals {
  // Centraliza a definição dos buckets para facilitar o gerenciamento
  s3_buckets = {
    flow_logs = {
      suffix = "-vpc-flow-logs"
    },
    access_logs = {
      suffix = "-s3-access-logs"
    }
  }
}

data "aws_caller_identity" "current" {}

################################################################################
########################## S3 Policy document ##################################
################################################################################

data "aws_iam_policy_document" "flow_logs_key_policy" {
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid    = "Allow Flow Logs to use the key"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions   = ["kms:GenerateDataKey*"]
    resources = ["*"]
  }
}

################################################################################
################################### KMS Keys ###################################
################################################################################

resource "aws_kms_key" "flow_logs_key" {
  description             = "KMS key for VPC Flow Logs"
  deletion_window_in_days = 10
  policy                  = data.aws_iam_policy_document.flow_logs_key_policy.json
  enable_key_rotation     = true
  tags                    = merge({ Name = "${var.project_name}-vpc-flow-logs-key" }, var.default_tags)
}

resource "aws_kms_alias" "flow_logs_key_alias" {
  name          = "alias/${var.project_name}-flow-logs-key"
  target_key_id = aws_kms_key.flow_logs_key.id
}

################################################################################
############################### S3 Buckets #####################################
################################################################################

#tfsec:ignore:aws-s3-enable-bucket-logging:2025-10-30 Justified: Buckets are configured with logging and versioning in the resources below.
resource "aws_s3_bucket" "buckets" {
  for_each      = local.s3_buckets
  bucket        = lower("${var.project_name}${each.value.suffix}-${data.aws_caller_identity.current.account_id}")
  force_destroy = true  # Enabled to avoid errors on destroy
  tags          = merge({ Name = "${var.project_name}${each.value.suffix}" }, var.default_tags)
}

################################################################################
######################## S3 Bucket Configurations ##############################
################################################################################

resource "aws_s3_bucket_versioning" "s3_bucket_logs_versioning" {
  for_each = local.s3_buckets
  bucket   = "${var.project_name}${each.value.suffix}"
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_logging" "vpc_flow_log_bucket_logging" {
  bucket        = aws_s3_bucket.buckets["flow_logs"].id
  target_bucket = aws_s3_bucket.buckets["access_logs"].id
  target_prefix = "log/"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_sse" {
  for_each = aws_s3_bucket.buckets
  bucket   = each.value.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.flow_logs_key.arn
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  for_each                = aws_s3_bucket.buckets
  bucket                  = each.value.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

################################################################################
############################### VPC Flow Logs ##################################
################################################################################

resource "aws_flow_log" "main_vpc_flow_log_s3" {
  log_destination      = aws_s3_bucket.buckets["flow_logs"].arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.main.id
  tags                 = merge({ Name = "${var.project_name}-vpc-flow-log" }, var.default_tags)
}