terraform {
  backend "s3" {
    bucket  = "my-company-terraform-state-001"
    key     = "app/terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true
  }
}

