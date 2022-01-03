// data source represents a piece of read-only information that is fetched from the provider (aws in our case)
// every time terraform is run
// data that can be queried include vpc, subnet, ami ids, ip address ranges, current user identity etc
// config is a search parameter
// TODO: Create own vpc, deploy in the vpc of choice, make this a variable


data "aws_security_group" "default_sg" {
  filter {
    name = "vpc-id"
    values = [local.vpc_id]
  }
  filter {
    name = "group-id"
    values = ["sg-9799d7e1"]
  }
}

data "template_file" "user_data" {
    template = file("${path.module}/user-data.sh")
    vars = {
      server_port = var.webserver_port,
      db_address  = local.mysql_config.address
      db_port     = local.mysql_config.port
      server_text = var.server_text
    }
}
