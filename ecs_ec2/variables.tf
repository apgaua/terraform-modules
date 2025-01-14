variable "region" {
    type = string
}
variable "project_name" {
    type = string
}
variable "ssm_vpc_id" {
    type = string
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

variable "load_balancer_internal" {}

variable "load_balancer_type" {}

variable "nodes_ami" {}

variable "node_instance_type" {}

variable "node_volume_size" {}

variable "node_volume_type" {}

variable "cluster_ondemand_min" {}

variable "cluster_ondemand_max" {}

variable "cluster_ondemand_desired" {}

variable "cluster_spot_min" {}

variable "cluster_spot_max" {}

variable "cluster_spot_desired" {}