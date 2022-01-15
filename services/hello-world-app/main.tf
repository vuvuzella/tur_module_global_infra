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
  any_protocol  = "-1"
  tcp_protocol  = "tcp"
  all_ipv4      = ["0.0.0.0/0"]
  all_ipv6      = ["::/0"]

  # since data sources now use the count parameter, they are now an array
  # hence we use index in an array to get their ids
  subnet_ids = (var.subnet_ids == null
    ? data.aws_subnet_ids.default[0].ids
    : var.subnet_ids)

  # since data sources now use the count parameter, they are now an array
  # hence we use index in an array to get their ids
  mysql_config = (var.mysql_config == null
    ? data.terraform_remote_state.db[0].outputs
    : var.mysql_config)

  # since data sources now use the count parameter, they are now an array
  # hence we use index in an array to get their ids
  vpc_id = (var.vpc_id == null
    ? data.aws_vpc.default[0].id
    : var.vpc_id
  )
}

module "asg" {
  // Using local file system to reference the modules requires 6 dereferences when using terragrunt
  // source = "../../../../../../../modules/cluster/asg-rolling-deploy"
  source = "../../cluster/asg-rolling-deploy"

  cluster_name        = "hello-world-${var.environment}"
  ami                 = var.ami
  user_data           = data.template_file.user_data.rendered
  instance_type       = var.instance_type

  min_size            = var.min_size
  max_size            = var.max_size
  enable_autoscaling  = var.enable_autoscaling

  subnet_ids          = local.subnet_ids
  target_group_arns   = [aws_lb_target_group.asg.arn]
  health_check_type   = "ELB"

  custom_tags         = var.custom_tags

}

module "alb" {
  // Using local file system to reference the modules requires 6 dereferences when using terragrunt
  // source = "../../../../../../../modules/network/alb"
  source = "../../network/alb"

  alb_name = "hello-world-${var.environment}"
  subnet_ids = local.subnet_ids
}

resource "aws_lb_target_group" "asg" {
  name      = "hello-world-${var.environment}"
  port      = var.webserver_port
  protocol  = "HTTP"
  vpc_id    = local.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = "15"
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = module.alb.alb_http_listener_arn
  priority = 100
  condition {
    path_pattern {
      values = ["*"]
    }
  }
  action {
    type              = "forward"
    target_group_arn  = aws_lb_target_group.asg.arn
  }
}
