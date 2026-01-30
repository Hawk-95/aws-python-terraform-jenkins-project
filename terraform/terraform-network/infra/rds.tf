resource "random_password" "db" {
  length  = 16
  special = true
}

resource "aws_secretsmanager_secret" "db_secret" {
  name = "rds-db-credentials-v2"
}

resource "aws_secretsmanager_secret_version" "db_secret_value" {
  secret_id = aws_secretsmanager_secret.db_secret.id

  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db.result
  })
}

resource "aws_db_subnet_group" "this" {
  name       = "db-subnet-group"
  subnet_ids = [
   aws_subnet.private_1.id,
   aws_subnet.private_2.id
  ]

}

resource "aws_db_instance" "this" {
  identifier           = "app-db"
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20

  db_name              = var.db_name
  username             = var.db_username
  password             = random_password.db.result

  db_subnet_group_name = aws_db_subnet_group.this.name
  vpc_security_group_ids = [
    aws_security_group.db_sg.id
  ]

  publicly_accessible = false
  skip_final_snapshot = true
}

