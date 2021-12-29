provider "aws" {
  profile = "admin-dev"
  region = "ap-southeast-2"
}

terraform {
  required_version = ">=0.12"
  # partial configuration. The rest will be filled up by terragrunt
  backend "s3" {}
}


data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = var.db_password_secrets_id
}

resource "aws_db_instance" "db_example" {
  identifier_prefix         = var.db_prefix
  engine                    = "mysql"
  allocated_storage         = var.db_allocated_storage
  instance_class            = var.db_instance_class
  name                      = var.db_name
  username                  = var.db_admin_username
  password                  = jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string).value
  skip_final_snapshot       = var.db_skip_final_snapshot
  final_snapshot_identifier = "${var.db_final_snapshot_name}"

  lifecycle {
    create_before_destroy = true
  }
}
