output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_additional_cidrs" {
  value = aws_vpc_ipv4_cidr_block_association.main[count.index].id
}