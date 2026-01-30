module "infra" {
  source = "./infra"

  vpc_cidr               = var.vpc_cidr
  public_subnet_cidr     = var.public_subnet_cidr
  private_subnet_1_cidr  = var.private_subnet_1_cidr
  private_subnet_2_cidr  = var.private_subnet_2_cidr

  db_name     = var.db_name
  db_username = var.db_username
}

