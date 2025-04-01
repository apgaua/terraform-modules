#VPC Variables
variable "project_name" {
  type    = string
  default = "Name of the project"
}

variable "vpc_cidr" {
  type        = string
  description = "Main CIDR"
}

variable "vpc_additional_cidrs" {
  type        = list(string)
  description = "VPC additional CIDRs"
  default     = [""]
}

variable "default_tags" {
  type = map(string)
  default = {
    contato = ""
    dia     = ""
    repo    = ""
  }
  description = "Default tags to be set in resources"
}

variable "region" {
  type        = string
  description = "The AWS region that the structure will be deployed"
}

variable "publicsubnets" {
  type        = list(string)
  description = "Public subnet CIDR"
}

variable "privatesubnets" {
  type        = list(string)
  description = "Private subnet CIDR"
}

variable "podsubnets" {
  type        = list(string)
  description = "POD subnet CIDR"
  default     = []
}

variable "databasesubnets" {
  type        = list(string)
  description = "Database subnet CIDR"
  default     = []
}

variable "database_nacl_rules" {
  # type = list(object({
  #   rule_start_number = number
  #   rule_action       = string
  #   protocol          = string
  #   from_port         = optional(number)
  #   to_port           = optional(number)
  # }))
  type        = list(map(string))
  description = "NACL rules that will be created in database subnet"
  default     = []
}

variable "singlenat" {
  type        = bool
  default     = true
  description = "Should it be deploy with a single NAT Gateway? If set to false, it will be deployed one each AZ"
}