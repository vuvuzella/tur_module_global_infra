provider "aws" {
  profile = "admin-dev"
  region = "ap-southeast-2"
}

terraform {
  backend "s3" {
    bucket          = "admin-dev-tf-state"
    key             = "test/alb/terraform.tfstate"
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

module "test" {
  source = "../"
  alb_name = "tur-alb-test"
  subnet_ids = data.aws_subnet_ids.default.ids
}

output "alb_dns_name" {
    value = module.test.alb_dns_name
}
