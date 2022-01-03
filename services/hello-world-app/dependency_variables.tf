variable "db_remote_state_bucket" {
  description = "The name of the s3 bucket for the database's remote state"
  type        = string
  default     = null
}

variable "db_remote_state_key" {
  description = "The path for the database's remote state in s3"
  type        = string
  default     = null
}

variable "tf_remote_state_profile" {
  description = "the profile to be used when retrieving the remote state "
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to deploy into"
  type = string
  default = null
}

variable "subnet_ids" {
  description = "The IDs of the subnets to deploy into"
  type = list(string)
  default = null
}

variable "mysql_config" {
  description = "The config for the MySQL db"
  type = object({
    address = string
    port    = number
  })
  default = null
}
