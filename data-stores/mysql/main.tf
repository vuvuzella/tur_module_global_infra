provider "aws" {
  profile = "admin-dev"
  region = "ap-southeast-2"
}
// 
// terraform {
//   backend "s3" {
//     bucket          = "admin-dev-tf-state"
//     key             = "stage/data-stores/mysql/terraform.tfstate"
//     region          = "ap-southeast-2"
//     dynamodb_table  = "terraform-up-and-running-locks"
//     encrypt         = true
//     profile         = "admin-dev"
//   }
// }

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = var.db_password_secrets_id
}

resource "aws_db_instance" "db_example" {
  identifier_prefix = var.db_prefix
  engine            = "mysql"
  allocated_storage = var.db_allocated_storage
  instance_class    = var.db_instance_class
  name              = var.db_name
  username          = var.db_admin_username
  password          = jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string).value
}
