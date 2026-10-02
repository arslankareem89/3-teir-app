resource "aws_db_subnet_group" "this" {
  name       = "tier3-app-db-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name        = "${var.project_name}-db-subnet-group"
    Project     = var.project_name
    Environment = "dev"
  }
}

resource "aws_db_instance" "this" {
  identifier = "tier3-app-postgres"

  engine         = "postgres"
  engine_version = var.engine_version

  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.master_username

  manage_master_user_password = true

  port = 5432

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.security_group_id]

  publicly_accessible = false

  multi_az = false

  backup_retention_period  = 1
  delete_automated_backups = true

  auto_minor_version_upgrade = true
  copy_tags_to_snapshot      = true

  deletion_protection = false
  skip_final_snapshot = true

  apply_immediately = true

  tags = {
    Name        = "${var.project_name}-postgres"
    Project     = var.project_name
    Environment = "dev"
  }
}