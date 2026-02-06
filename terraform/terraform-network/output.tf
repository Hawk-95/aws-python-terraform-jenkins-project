############################################
# VPC + Subnets
############################################

output "vpc_id" {
  value = module.infra.vpc_id
}

output "public_subnet_ids" {
  value = module.infra.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.infra.private_subnet_ids
}

############################################
# RDS Outputs
############################################

output "rds_endpoint" {
  value = module.infra.rds_endpoint
}

output "db_secret_arn" {
  value = module.infra.db_master_secret_arn
}

############################################
# IAM Outputs (IMPORTANT for ASG / Launch Template)
############################################

output "app_instance_profile_name" {
  value = module.infra.app_instance_profile_name
}

