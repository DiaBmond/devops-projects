# ========================================
# Outputs
# ========================================

output "vpc_id" {
  description = "ID for VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block for VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_id" {
  description = "ID for Public Subnet"
  value       = aws_subnet.public.id
}

output "internet_gateway_id" {
  description = "ID for Internet Gateway"
  value       = aws_internet_gateway.main.id
}
