output "vpc_id" {
  value = aws_vpc.main.id
}

# output "vpc_additional_cidrs" {
#   value = [for i in aws_vpc_ipv4_cidr_block_association.main : i.id]
# }