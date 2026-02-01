output "vpc_id" {
  value = aws_vpc.this.id
}

output "rds_endpoint" {
  value = aws_db_instance.this.endpoint
}

output "db_master_secret_arn" {
  value = aws_db_instance.this.master_user_secret[0].secret_arn
}
