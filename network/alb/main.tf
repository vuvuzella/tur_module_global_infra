locals {
  http_port     = 80
  any_protocol  = "-1"
  all_ipv4      = ["0.0.0.0/0"]
  all_ipv6      = ["::/0"]
}

resource "aws_lb" "example" {
  name                = var.alb_name
  load_balancer_type  = "application"
  subnets             = var.subnet_ids
  security_groups     = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn   = aws_lb.example.arn
  port                = local.http_port
  protocol            = "HTTP"
  // by default, return a simple 404 page
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type    = "text/plain"
      message_body    = "404: page not found"
      status_code     = 404
    }
  }
}


resource "aws_security_group" "alb" {
  name = var.alb_name
}

resource "aws_security_group_rule" "allow_http_inbound" {
  security_group_id = aws_security_group.alb.id

  type              = "ingress"
  cidr_blocks       = local.all_ipv4
  description       = "ingress for application load balancer"
  from_port         = local.http_port
  protocol          = "tcp"
  to_port           = local.http_port
}

resource "aws_security_group_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.alb.id

  type              = "egress"
  cidr_blocks       = local.all_ipv4
  description       = "egress for application load balancer"
  from_port         = local.http_port
  protocol          = local.any_protocol
  to_port           = local.http_port
}
