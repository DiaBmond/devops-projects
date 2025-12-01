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

# EC2 Outputs
output "instance_id" {
  description = "ID ของ EC2 instance"
  value       = aws_instance.web.id
}

output "instance_public_ip" {
  description = "Public IP ของ EC2"
  value       = aws_instance.web.public_ip
}

output "instance_public_dns" {
  description = "Public DNS ของ EC2"
  value       = aws_instance.web.public_dns
}

output "security_group_id" {
  description = "ID ของ Security Group"
  value       = aws_security_group.web.id
}

output "website_url" {
  description = "URL เข้าเว็บไซต์"
  value       = "http://${aws_instance.web.public_ip}"
}
