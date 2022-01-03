variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
}

variable "ami" {
  description = "The AMI to run in the cluster"
  type        = string
  default     = "ami-0567f647e75c7bc05"
}

variable "instance_type" {
  description = "The type of ec2 instance to run"
  type        = string
}

variable "min_size" {
  description = "The minimum number of ec2 instance in the ASG"
  type        = number
}

variable "max_size" {
  description = "The maximum number of ec2 instance in the ASG"
  type        = number
}

variable "enable_autoscaling" {
  description = "Enable ASG auto scaling on or off"
  type        = bool
}

variable "custom_tags" {
  description = "Custom tags to set on the instances in the ASG"
  type        = map(string)
  default     = {}
}

variable "webserver_port" {
  default     = 8080
  description = "port used for the webserver"
  type        = number
}

variable "subnet_ids" {
  description = "Subnet ids to deploy to" # This allows the module to be deployed in any custom VPCs
  type = list(string)
}

variable "target_group_arns" {
  description = "The ARNs of ELB target groups in which to register Instances"
  type = list(string)
  default = []
}

variable "health_check_type" {
  description = "The type of health check to perform. Must be one of EC2 or ELB"
  type = string
  default = "EC2"
}

variable "user_data" {
  description = "The User Data script to run in each Instance at boot"
  type = string
  default = ""
}
