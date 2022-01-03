variable "alb_name" {
  type = string
  description = "Name of the Application Load Balancer resource"
}

variable "subnet_ids" {
  type = list(string)
  description = "The subnet IDs to deploy to"
}
