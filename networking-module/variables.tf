#VPC Variables
variable "project_name" {
  type    = string
  default = "Name of the project, it will be used in the tags and naming of resources"
}

variable "vpc_cidr" {
  type        = string
  description = "Main VPC CIDR"
}

variable "vpc_additional_cidrs" {
  type        = list(string)
  description = "Additional VPC CIDRs"
  default     = [""]
}

variable "nat_instance_max_price" {
  type        = string
  default     = "0.005"
  description = "Max price for spot NAT instance"
}

variable "default_tags" {
  type = map(string)
  default = {
    Contato = ""
    Repo    = ""
  }
  description = "Default tags to be set in resources"
}

variable "region" {
  type        = string
  description = "The AWS region that the structure will be deployed"
}

variable "publicsubnets" {
  type        = list(string)
  description = "Public subnet values"
}

variable "privatesubnets" {
  type        = list(string)
  description = "Private subnet values"
}

variable "podsubnets" {
  type        = list(string)
  description = "POD subnet values"
  default     = []
}

variable "databasesubnets" {
  type        = list(string)
  description = "Database subnet values"
  default     = []
}

variable "database_nacl_rules" {
  type        = list(map(string))
  description = "ACL rule to database subnet"
  default     = []
}

variable "singlenat" {
  type        = bool
  default     = true
  description = "If true, create a single NAT Gateway/Instance in the first AZ. If false, create a NAT Gateway/Instance in each public subnet."
}

variable "nat_gateway_type" {
  type        = string
  default     = "INSTANCE"
  description = "Type of NAT Gateway to create: GATEWAY or INSTANCE"
}