# ========================================
# Local Values
# ========================================
# Locals = ค่าที่คำนวณหรือรวมจาก variables

locals {
  # Common naming prefix
  name_prefix = "${var.project_name}-${var.environment}"

  # Common tags รวมกับ environment-specific tags
  common_tags = merge(
    var.common_tags,
    {
      Name        = local.name_prefix
      Environment = var.environment
      Region      = var.aws_region
    }
  )

  # Security Group rules as structured data
  ingress_rules = {
    ssh = {
      description = "SSH from allowed IPs"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.allowed_ssh_ips
    }
    http = {
      description = "HTTP from anywhere"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # User data template variables
  user_data_vars = {
    project_name  = var.project_name
    environment   = var.environment
    region        = var.aws_region
    instance_type = var.instance_type
  }
}
