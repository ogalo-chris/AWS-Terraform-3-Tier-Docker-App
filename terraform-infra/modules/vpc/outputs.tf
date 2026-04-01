output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "frontend_subnet_ids" {
  value = aws_subnet.private_frontend_subnet[*].id
}

output "backend_subnet_ids" {
  value = aws_subnet.private_backend_subnet[*].id
}

output "database_subnet_ids" {
  value = aws_subnet.private_database_subnet[*].id
}

output "nat_gateway_ids" {
  value = var.enable_nat_gateway ? aws_nat_gateway.nat_gateway[*].id : []
}

output "internet_gateway_id" {
  value = aws_internet_gateway.main_ig.id
}
output "vpc_cidr_block" {
  value = aws_vpc.main_vpc.cidr_block
}

output "nat_gateway_ips" {
  description = "Elastic IPs of NAT Gateways"
  value       = aws_eip.nat_eip[*].public_ip
}