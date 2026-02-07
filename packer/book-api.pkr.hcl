packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ami_name_prefix" {
  type    = string
  default = "book-api"
}

variable "ssh_username" {
  type    = string
  default = "ec2-user"
}

source "amazon-ebs" "book_api_ami" {
  region        = var.aws_region
  instance_type = var.instance_type

  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-*-x86_64-gp2"
      virtualization-type = "hvm"
      root-device-type    = "ebs"
    }
    owners      = ["amazon"]
    most_recent = true
  }

  ssh_username = var.ssh_username

  ami_name = "${var.ami_name_prefix}-${formatdate("YYYYMMDD-hhmmss", timestamp())}"

  tags = {
    Project = "book-api"
    BuiltBy = "packer"
  }
}

build {
  name    = "book-api-build"
  sources = ["source.amazon-ebs.book_api_ami"]

  provisioner "shell" {
    script = "scripts/install_dependencies.sh"
  }

  # ✅ Upload your local book-app folder into the EC2
  provisioner "file" {
    source      = "../book-app"
    destination = "/tmp/book-app"
  }

  provisioner "shell" {
    script = "scripts/setup_app.sh"
  }

  provisioner "file" {
    source      = "scripts/book-api.service"
    destination = "/tmp/book-api.service"
  }

  provisioner "shell" {
    inline = [
      "sudo mv /tmp/book-api.service /etc/systemd/system/book-api.service",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable book-api",
      "sudo systemctl start book-api"
    ]
  }
}

