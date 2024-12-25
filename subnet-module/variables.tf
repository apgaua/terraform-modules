variable "vpc_id" {
    description = "VPC ID"
    type = string
}
variable "cidr_block" {
    description = "List of CIDRs"
    type = string
}
variable "availability_zone" {
    description = "AZ expected to deploy"
    type = string
}
variable "name" {
    description = "Name of the resource"
    type = string
}