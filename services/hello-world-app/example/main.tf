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

module "mysql" {
  // source = "../../../../../../../modules/data-stores/mysql"
  source = "../../../data-stores/mysql"

  db_name                 = "mysql-test"
  db_password_secrets_id  = "mysql-master-password-stage"
}

module "hello_world_app" {
  source = "../"
  
  min_size                = 2
  max_size                = 2
  environment             = "test"
  instance_type           = "t2.micro"
  tf_remote_state_profile = "admin-dev"
  enable_autoscaling      = false

  server_text             = "Testing module"

  mysql_config            = module.mysql
}
