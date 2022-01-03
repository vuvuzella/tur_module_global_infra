provider "aws" {
  profile = "admin-dev"
  region = "ap-southeast-2"
}

terraform {
  required_version = ">=0.12"
  // backend "s3" {}
}

locals {
  http_port     = 80
  any_port      = 0
  any_protocol  = "-1"
  all_ipv4      = ["0.0.0.0/0"]
  all_ipv6      = ["::/0"]
}

// TODO: Template File as a variable?
resource "aws_launch_configuration" "example" {
    image_id        = var.ami
    instance_type   = var.instance_type
    security_groups = [aws_security_group.ec2instance_example_sg.id]
    user_data       = var.user_data

    // create_before destroy is required when using a launch config with auto scaling group
    // https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "example" {
  name                  = "${var.cluster_name}-${aws_launch_configuration.example.name}"
  launch_configuration  = aws_launch_configuration.example.name
  vpc_zone_identifier   = var.subnet_ids

  // take advantage of first-class integration between ASG and ALB
  target_group_arns     = var.target_group_arns
  health_check_type     = var.health_check_type   // default is EC2. 

  // instance_type   = var.instance_type
  min_size              = var.min_size
  max_size              = var.max_size

  // Wait for at least this many instances to pass health checks
  // before considering the ASG deployment complete
  min_elb_capacity      = var.min_size

  lifecycle {
    create_before_destroy = true
  }
  
  tag {
      key                 = "Name"
      value               = "${var.cluster_name}-example"
      propagate_at_launch = true
  }

  dynamic "tag" {
      for_each = var.custom_tags
      content {
          key                 = tag.key
          value               = tag.value
          propagate_at_launch = true
      }
  }
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  count = var.enable_autoscaling ? 1 : 0
  scheduled_action_name = "${var.cluster_name}-scale-out-during-business-hours"
  min_size = var.min_size
  max_size = var.max_size
  desired_capacity = var.max_size
  recurrence = "0 9 * * *"
  autoscaling_group_name = aws_autoscaling_group.example.name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  count = var.enable_autoscaling ? 1 : 0
  scheduled_action_name = "${var.cluster_name}-scale-in-at-night"
  min_size = var.min_size
  max_size = var.max_size
  desired_capacity = var.min_size
  recurrence = "0 17 * * *"
  autoscaling_group_name = aws_autoscaling_group.example.name
}

resource "aws_security_group" "ec2instance_example_sg" {
  name = "${var.cluster_name}-instance"
  ingress = [{
    cidr_blocks         = local.all_ipv4
    ipv6_cidr_blocks    = local.all_ipv6
    description         = "accept all incoming traffic from all ip addresses"
    from_port           = var.webserver_port
    protocol            = "tcp"
    to_port             = var.webserver_port
    prefix_list_ids     = []
    security_groups     = []
    self                = true  // whether the security group itself will be added as source to the ingress/egress rule
  }]
  tags = {
    name = "nonprod-webserver-cluster"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization" {
  alarm_name = "${var.cluster_name}-high-cpu-utilization"
  namespace = "AWS/EC2"
  metric_name = "CPUUtilization"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.example.name
  }

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = 1
  period = 300
  statistic = "Average"
  threshold = 90
  unit = "Percent"
}

resource "aws_cloudwatch_metric_alarm" "low_cpu_credit_balance" {
  # extract just the first character, check if it is "t"
  count               = format("%.1s", var.instance_type) == "t" ? 1 : 0  # only create this alarm if the instance type is tXXX

  alarm_name          = "${var.cluster_name}-low-cpu-credit-balance"
  namespace           = "AWS/EC2"
  metric_name         = "CPUCreditBalance"

  dimensions          = {
    AutoScalingGroupName = aws_autoscaling_group.example.name
  }

  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  period              = 300
  statistic           = "Minimum"
  threshold           = 10
  unit                = "Count"
}
