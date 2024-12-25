variable "vpc_id" {
    description = "VPC ID"
    type = string
}

variable "subnets" {
  description = "Lista de subnets de banco de dados"
  default     = []
  type = list(object({
    name              = string
    cidr              = string
    availability_zone = string
  }))
}

variable 