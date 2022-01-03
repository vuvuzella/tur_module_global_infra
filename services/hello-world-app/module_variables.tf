//  values in the variables can be changed either by
//      1. as an argument to switch -var or -var-file
//      2. Environment Variables TF_VAR_<variable name>
// types: string, number, bool, list(type), map, set, object, tuple, any
variable "webserver_port" {
  default     = 8080
  description = "port used for the webserver"
  type        = number
}

variable "server_text" {
  description = "The text the server should return"
  type        = string
  default     = "Hello World"
}

variable environment {
  description = "The name of the environment we're deploying to"
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
