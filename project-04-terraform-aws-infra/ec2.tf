# ========================================
# Data Source: AMI
# ========================================
# หา Amazon Linux 2 AMI ล่าสุด

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ========================================
# EC2 Instance
# ========================================
# Virtual Server

resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro" # Free tier
  subnet_id              = aws_subnet.public.id
  key_name               = "devops-project4-key"
  vpc_security_group_ids = [aws_security_group.web.id]

  # User Data - รันตอน boot
  user_data = <<-EOF
            #!/bin/bash
            yum update -y
            amazon-linux-extras install nginx1 -y
            systemctl start nginx
            systemctl enable nginx
            
            cat > /usr/share/nginx/html/index.html <<HTML
            <!DOCTYPE html>
            <html>
            <head>
                <title>DevOps Project 4</title>
                <style>
                    body {
                        font-family: Arial, sans-serif;
                        text-align: center;
                        margin-top: 100px;
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                    }
                    .container {
                        background: rgba(255,255,255,0.1);
                        padding: 50px;
                        border-radius: 10px;
                        display: inline-block;
                    }
                    h1 { font-size: 48px; margin: 0; }
                    p { font-size: 24px; }
                    .tech { 
                        background: rgba(255,255,255,0.2);
                        padding: 10px 20px;
                        border-radius: 5px;
                        margin: 10px;
                        display: inline-block;
                    }
                </style>
            </head>
            <body>
                <div class="container">
                    <h1>DevOps Project 4</h1>
                    <p>Infrastructure as Code with Terraform</p>
                    <div>
                        <span class="tech">Terraform</span>
                        <span class="tech">AWS</span>
                        <span class="tech">EC2</span>
                        <span class="tech">VPC</span>
                    </div>
                    <p style="margin-top: 30px; font-size: 18px;">
                        Server deployed successfully!
                    </p>
                </div>
            </body>
            </html>
HTML
            EOF

  tags = {
    Name = "devops-web-server"
  }
}
