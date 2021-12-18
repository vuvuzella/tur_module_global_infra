variable "db_password_secrets_id" {
  type = string
  description = "The secrets manager id where the password for the database is located"
}

variable "db_name" {
  type = string
  description = "the name of the database"
}

variable "db_admin_username" {
  type = string
  description = "the admin username for the database"
  default = "admin_dev"
}

variable "db_instance_class" {
  type = string
  description = "the instance class to be used by AWS RDS"
  default = "db.t2.micro"
}

variable "db_prefix"  {
  type = string
  description = "the prefix for the database"
  default = "terraform-up-and-running"
}

variable "db_allocated_storage" {
  type = number
  description = "The number of allocated storage"
  default = 10
}