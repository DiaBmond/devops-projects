# Project 4: Terraform Variables Guide

## 📋 Available Variables

### Project Configuration

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `project_name` | string | `"devops-project4"` | Project name for resource naming |
| `environment` | string | `"dev"` | Environment (dev, staging, prod) |

### AWS Configuration

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `aws_region` | string | `"ap-southeast-1"` | AWS region |
| `availability_zone` | string | `"ap-southeast-1a"` | Availability zone |

### Network Configuration

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `vpc_cidr` | string | `"10.0.0.0/16"` | VPC CIDR block |
| `public_subnet_cidr` | string | `"10.0.1.0/24"` | Public subnet CIDR |

### EC2 Configuration

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `instance_type` | string | `"t2.micro"` | EC2 instance type |
| `key_name` | string | `"devops-project4-key"` | SSH key pair name |

### Security Configuration

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `allowed_ssh_ips` | list(string) | `["0.0.0.0/0"]` | IPs allowed to SSH |

---

## 🔧 How to Use Variables

### Method 1: terraform.tfvars (Recommended)

Create `terraform.tfvars`:
```hcl
project_name = "my-project"
environment  = "production"
instance_type = "t3.micro"
```

### Method 2: Command Line
```bash
terraform apply -var="project_name=my-project" -var="environment=prod"
```

### Method 3: Environment Variables
```bash
export TF_VAR_project_name="my-project"
export TF_VAR_environment="prod"
terraform apply
```

### Method 4: .auto.tfvars

Create `production.auto.tfvars`:
```hcl
environment = "production"
instance_type = "t3.micro"
```

Files ending in `.auto.tfvars` are automatically loaded.

---

## 🌍 Multi-Environment Setup

### Development
```hcl
# dev.tfvars
environment   = "dev"
instance_type = "t2.micro"
vpc_cidr      = "10.0.0.0/16"
```

### Production
```hcl
# prod.tfvars
environment   = "prod"
instance_type = "t3.small"
vpc_cidr      = "10.1.0.0/16"
```

**Usage:**
```bash
# Development
terraform apply -var-file="dev.tfvars"

# Production
terraform apply -var-file="prod.tfvars"
```

---

## 🔒 Security Best Practices

### ❌ Don't Commit Secrets
```gitignore
# .gitignore
terraform.tfvars
*.auto.tfvars
secrets.tfvars
```

### ✅ Use Example Files

Create `terraform.tfvars.example`:
```hcl
project_name = "CHANGE_ME"
environment  = "dev"
```

### ✅ Use AWS Secrets Manager (Advanced)
```hcl
data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "prod/database/password"
}

locals {
  db_password = jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)["password"]
}
```

---

## 📊 Variable Validation Examples

### CIDR Validation
```hcl
variable "vpc_cidr" {
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "Must be valid CIDR."
  }
}
```

### String Length
```hcl
variable "project_name" {
  validation {
    condition     = length(var.project_name) <= 20
    error_message = "Project name must be 20 chars or less."
  }
}
```

### Allowed Values
```hcl
variable "environment" {
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Must be dev, staging, or prod."
  }
}
```

---

## 💡 Tips & Tricks

### View All Variable Values
```bash
terraform console
> var.project_name
> var.vpc_cidr
```

### Override Specific Variable
```bash
terraform apply -var="instance_type=t3.micro"
```

### Use Locals for Computed Values
```hcl
locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

resource "aws_vpc" "main" {
  tags = {
    Name = local.name_prefix  # "myproject-dev"
  }
}
```

---

## 🎯 Common Patterns

### Environment-Specific Configurations
```hcl
locals {
  instance_config = {
    dev = {
      instance_type = "t2.micro"
      instance_count = 1
    }
    prod = {
      instance_type = "t3.large"
      instance_count = 3
    }
  }
  
  current_config = local.instance_config[var.environment]
}

resource "aws_instance" "web" {
  count         = local.current_config.instance_count
  instance_type = local.current_config.instance_type
}
```

### Conditional Resources
```hcl
resource "aws_instance" "bastion" {
  count = var.environment == "prod" ? 1 : 0
  # Only create in production
}
```

---

## 📚 References

- [Terraform Variables](https://www.terraform.io/language/values/variables)
- [Input Variable Validation](https://www.terraform.io/language/values/variables#custom-validation-rules)
- [Local Values](https://www.terraform.io/language/values/locals)
