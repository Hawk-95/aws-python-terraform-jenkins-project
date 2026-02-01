output "vpc_id" {
  value = module.infra.vpc_id
}

output "rds_endpoint" {
  value = module.infra.rds_endpoint
}

output "db_secret_arn" {
  value = module.infra.db_master_secret_arn
}

