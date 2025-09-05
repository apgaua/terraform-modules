variable "project_name" {
  type = string
}

variable "region" {
  type = string
}

################################################################################
########################### CLUSTER VARIABLES ##################################
################################################################################

variable "cluster" {
  type = list(object({
    kubernetes_version = string
    zonal_shift        = bool
    access_config = optional(object({
      authentication_mode                         = string
      bootstrap_cluster_creator_admin_permissions = bool
    }))
    upgrade_policy_support_type = string
    enabled_cluster_log_types   = list(string)
    addons = optional(list(object({
      name    = string
      version = string
    })), [])
  }))
}

################################################################################
############################## NODES VARIABLES #################################
################################################################################

variable "nodegroup" {
  type = list(object({
    node_group_name = string
    instance_types  = list(string)
    capacity_type   = optional(string, "SPOT") # or ON_DEMAND
    auto_scale_options = list(object({
      min     = number
      max     = number
      desired = number
    }))
    labels = optional(map(string), {})
  }))
}

################################################################################
#################################### HELM CHARTS ###############################
################################################################################

variable "helm_charts" {
  type = list(object({
    name             = string
    repository       = string
    chart            = string
    namespace        = string
    create_namespace = optional(bool, false)
    wait             = optional(bool, false)
    version          = optional(string, null)
    set = optional(list(object({
      name  = string
      value = string
    })), [])
  }))
  default = []
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