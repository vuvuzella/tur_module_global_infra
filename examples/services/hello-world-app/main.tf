provider "aws" {
  profile   = "admin-dev"
  region    = "ap-southeast-2"
}

terraform {
  backend "s3" {
    bucket          = "admin-dev-tf-state"
    key             = "test/services/hello-world-app/terraform.tfstate"
    region          = "ap-southeast-2"
    dynamodb_table  = "terraform-up-and-running-locks"
    encrypt         = true
    profile         = "admin-dev" 
  }
}

variable "mysql_config" {
  type = object({
    address = string
    port = string
  })
  description = "Outputs from the mysql data store module"

  default = {
    address = "default address"
    port = "12345"
  }
}

module "hello_world_app" {
  source = "../../../services/hello-world-app"
  
  min_size                = 2
  max_size                = 2
  environment             = var.environment
  instance_type           = "t2.micro"
  tf_remote_state_profile = "admin-dev"
  enable_autoscaling      = false

  server_text             = "Testing module"

  mysql_config            = var.mysql_config
}

variable "environment" {
  type = string
  description = "Name for the hello world app sample test"
  default = "Example"
}

output "alb_dns_name" {
  value = module.hello_world_app.alb_dns_name
}
