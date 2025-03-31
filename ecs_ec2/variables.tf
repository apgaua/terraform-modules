variable "region" {
  type        = string
  description = "Specify AWS region"
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Resources name"
}

variable "ssm_vpc_id" {
  type    = string
  default = "/ECS/vpc/id"
}

variable "privatesubnets" {
  type = list(string)
}

variable "publicsubnets" {
  type = list(string)
}

variable "databasesubnets" {
  type = list(string)
}

##############################################################
################### LOAD BALANCER VARIABLES ##################
##############################################################

variable "load_balancer_internal" {
  type = bool

}
variable "load_balancer_type" {
  type = string
}

##############################################################
####################### ECS VARIABLES ########################
##############################################################

variable "nodes_ami" {
  type = string
}

variable "node_instance_type" {
  type = string
}

variable "node_volume_size" {
  type = number
}

variable "node_volume_type" {
  type = string
}

variable "cluster_ondemand_min" {
  type = number
}

variable "cluster_ondemand_max" {
  type = number
}

variable "cluster_ondemand_desired" {
  type = number
}

variable "cluster_spot_min" {
  type = number
}

variable "cluster_spot_max" {
  type = number
}

variable "cluster_spot_desired" {
  type = number
}

variable "cluster_spot_maxprice" {
  type = string
}