# ========================================
# Security Group
# ========================================

resource "aws_security_group" "web" {
  name_prefix = "${var.project_name}-web-sg-" # ← ใช้ name_prefix
  description = "Security group for web server"
  vpc_id      = aws_vpc.main.id

  # เพิ่มส่วนนี้
  lifecycle {
    create_before_destroy = true
  }


  # SSH
  ingress {
    description = "SSH from allowed IPs"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_ips # ใช้ variable
  }

  # HTTP
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-web-sg"
  }
}
