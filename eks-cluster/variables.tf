variable "project_name" {
  type = string
}

variable "region" {
  type = string
}

################################################################################
########################### CLUSTER VARIABLES ##################################
################################################################################

variable "kubernetes_version" {
  type    = string
  default = "1.27"
}

variable "zonal_shift" {
  type    = bool
  default = false
}

variable "upgrade_policy_support_type" {
  type    = string
  default = "STANDARD"
}

variable "auto_scale_options" {
  type = object({
    min     = number
    max     = number
    desired = number
  })
}

variable "node_instance_type" {
  type = list(string)
}

variable "addon_cni_version" {
  type    = string
  default = "v1.19.5-eksbuild.1"
}

variable "addon_coredns_version" {
  type    = string
  default = "v1.11.4-eksbuild.2"
}

variable "addon_kubeproxy_version" {
  type    = string
  default = "v1.32.0-eksbuild.2"
}

################################################################################
############################ SSM NETWORKING VARIABLES ##########################
################################################################################

variable "ssm_vpc_id" {
  type = string
}

variable "ssm_public_subnets" {
  type = list(string)
}

variable "ssm_private_subnets" {
  type = list(string)
}

variable "ssm_pod_subnets" {
  type = list(string)
}

################################################################################
################################ DEFAULT TAGS ##################################
################################################################################

variable "default_tags" {
  type        = map(string)
  description = "Default tags to be set in resources"
}