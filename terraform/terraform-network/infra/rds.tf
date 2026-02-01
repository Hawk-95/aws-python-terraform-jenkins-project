resource "aws_db_subnet_group" "this" {
  name = "db-subnet-group"

  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  tags = {
    Name = "app-db-subnet-group"
  }
}

resource "aws_db_instance" "this" {
  identifier              = "app-db"
  engine                  = "postgres"
  engine_version          = "15"                # Pin version (best practice)
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_encrypted       = true                # 🔐 Encrypt storage
  backup_retention_period = 7                   # 📦 Keep backups
  multi_az                = false               # Change to true for prod HA

  db_name                 = var.db_name
  username                = var.db_username

  # 🔐 Let AWS manage the password in Secrets Manager
  manage_master_user_password = true

  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.db_sg.id]

  publicly_accessible     = false
  skip_final_snapshot     = false               # safer for prod
  deletion_protection     = true                # 🚨 Prevent accidental delete

  tags = {
    Name = "app-postgres-db"
  }
}
