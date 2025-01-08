#VPC Variables
variable "project_name" {
  type = string
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR principal"
}

variable "vpc_additional_cidrs" {
  type        = list(string)
  description = "CIDRs adicionais"
  default     = []
}

variable "region" {
  type        = string
  description = "The AWS region"
}

variable "publicsubnets" {
  type = list(object({
    name              = string
    cidr              = string
    availability_zone = string
  }))
  description = "Public subnet CIDR"
}

variable "privatesubnets" {
  type = list(object({
    name              = string
    cidr              = string
    availability_zone = string
  }))
  description = "Private subnet CIDR"
}

variable "databasesubnets" {
  type = list(object({
    name              = string
    cidr              = string
    availability_zone = string
  }))
  description = "Database CIDR"
  default     = []
}

variable "database_nacl_rules" {
  type = list(object({
    rule_start_number = number
    rule_action       = string
    protocol          = string
    from_port         = optional(number)
    to_port           = optional(number)
  }))
  description = "ACL Rules to DB Subnet"
  default     = []
}