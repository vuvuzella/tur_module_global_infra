provider "aws" {
  profile = "admin-dev"         // make this to come from the environment variable
  region = "ap-southeast-2"     // make this to come from the environment variable
}

terraform {
  backend "s3" {
    bucket          = "admin-dev-tf-state"
    key             = "test/data-stores/mysql/terraform.tfstate"
    region          = "ap-southeast-2"
    dynamodb_table  = "terraform-up-and-running-locks"
    encrypt         = true
    profile         = "admin-dev" 
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

variable "db_name" {
  type = string
  description = "The name to set for the database"
  default = "TurDataStoreMysqlTestDefault"
}

variable "db_admin_username" {
  type = string
  description = "The admin username to use"
  default = null
}

locals {
  mysql_secrets_id = "mysql-master-password-stage"
}

module "example" {
  source = "../../../data-stores/mysql"
  db_password_secrets_id = local.mysql_secrets_id
  db_name = var.db_name
  db_admin_username = var.db_admin_username
}

output "db_admin_username" {
  value = module.example.admin_username
}
