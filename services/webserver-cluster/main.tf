// TODO: Fill in the rest of this using composable modules for the cluster and alb
provider "aws" {
  profile = "admin-dev"
  region = "ap-southeast-2"
}

terraform {
  required_version = ">=0.12"
  # partial configuration. The rest will be filled up by terragrunt
  backend "s3" {}
}
locals {
  // http_port     = 80
  // any_port      = 0
  any_protocol  = "-1"
  tcp_protocol  = "tcp"
  all_ipv4      = ["0.0.0.0/0"]
  all_ipv6      = ["::/0"]
}

// Read data-store/mysql's output data
// this is read-only.
// Uncomment this when mysql module has been deployed
data "terraform_remote_state" "db" {
    backend = "s3"
    config = {
      bucket    = var.db_remote_state_bucket
      key       = var.db_remote_state_key
      region    = "ap-southeast-2"
      profile   = var.tf_remote_state_profile
     }
}

data "template_file" "user_data" {
    // count = var.enable_new_user_data ? 0 : 1
    template = file("${path.module}/user-data.sh")
    vars = {
      server_port = var.webserver_port,
      db_address  = data.terraform_remote_state.db.outputs.address
      db_port     = data.terraform_remote_state.db.outputs.port
      server_text = var.server_text
    }
}

resource aws_launch_template "example" {
  instance_type = var.instance_type
}
