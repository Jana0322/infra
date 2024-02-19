variable "region" {
  description = "Region where RDS will be created"
  type = string
}

variable "identifier" {
    type = string
}

variable "engine" {
  type = string
}

variable "instance_class" {
  type = string
}
variable "username" {
  description = "username for RDS instance"
  type = string
}

variable "password" {
  description = "Password for the RDS instance"
  type = string
}

variable "storage" {
  description = "Storage for the RDS"
  type = number
}

variable "storage_type" {
  type = string
}

variable "final_snapshot_identifier" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

# variable "vpc_security_group_ids" {
#   type = list(string)
# }
