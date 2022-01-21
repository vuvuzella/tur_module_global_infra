provider "aws" {
  profile = "admin-dev"
  region = "ap-southeast-2"
}

terraform {
  backend "s3" {
    bucket          = "admin-dev-tf-state"
    key             = "test/network/alb/terraform.tfstate"  // make this to come from an environment variable or a test runner
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

locals {
  mysql_secrets_id = "mysql-master-password-stage"
}

module "alb_test" {
  alb_name = var.alb_name
  source = "../../../network/alb"
  subnet_ids = data.aws_subnet_ids.default.ids
}

variable "alb_name" {
  type = string
  description = "Name to set to the lab"
  default = "tur-alb"
}

output "alb_dns_name" {
  value = module.alb_test.alb_dns_name
}
