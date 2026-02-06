data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "my-company-terraform-state-001"
    key    = "network/terraform.tfstate"
    region = "ap-south-1"
  }
}

############################################
# ALB
############################################
module "alb" {
  source = "./modules/alb"

  vpc_id            = data.terraform_remote_state.network.outputs.vpc_id
  public_subnet_ids = data.terraform_remote_state.network.outputs.public_subnet_ids
}

############################################
# Launch Template (for ASG EC2)
############################################
module "launch_template" {
  source = "./modules/launch_template"

  ami_id                = var.app_ami
  vpc_id                = data.terraform_remote_state.network.outputs.vpc_id
  alb_security_group_id = module.alb.alb_sg_id

  # ✅ This is from your first terraform script iam.tf
  instance_profile_name = data.terraform_remote_state.network.outputs.app_instance_profile_name

  deployment_color = var.deployment_color
}

############################################
# Auto Scaling Group
############################################
module "asg" {
  source = "./modules/asg"

  launch_template_id = module.launch_template.launch_template_id
  target_group_arn   = module.alb.target_group_arn

  private_subnet_ids = data.terraform_remote_state.network.outputs.private_subnet_ids
  deployment_color   = var.deployment_color
}

