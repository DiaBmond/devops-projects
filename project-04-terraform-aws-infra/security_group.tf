# ========================================
# Security Group
# ========================================
# Security Group = Firewall

resource "aws_security_group" "web" {
  name        = "devops-web-sg"
  description = "Security group for web server"
  vpc_id      = aws_vpc.main.id

  # Ingress = Traffic in
  # SSH - port 22
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP - port 80
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress = Traffic out
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 = all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-web-sg"
  }
}
