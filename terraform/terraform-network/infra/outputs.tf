############################################
# VPC Outputs
############################################

output "vpc_id" {
  value = aws_vpc.this.id
}

############################################
# Subnet Outputs
############################################

output "public_subnet_ids" {
  value = [aws_subnet.public.id]
}

output "private_subnet_ids" {
  value = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]
}

############################################
# RDS Outputs
############################################

output "rds_endpoint" {
  value = aws_db_instance.this.endpoint
}

output "db_master_secret_arn" {
  value = aws_db_instance.this.master_user_secret[0].secret_arn
}

############################################
# IAM Outputs
############################################

output "app_instance_profile_name" {
  value = aws_iam_instance_profile.app_instance_profile.name
}

