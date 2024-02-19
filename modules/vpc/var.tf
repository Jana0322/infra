variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public1_subnet_cidr" {
  description = "CIDR blocks for public subnets"
  type        = string
}

variable "public2_subnet_cidr" {
  description = "CIDR blocks for public subnets"
  type        = string
}

variable "private1_subnet_cidr" {
  description = "CIDR blocks for private subnets"
  type        = string
}

variable "private2_subnet_cidr" {
  description = "CIDR blocks for private subnets"
  type        = string
}

variable "project_name_env" {
  description = "project_name_env"
  type        = string  
}

/*
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "environment" {
  description = "environment for the VPC"
  type        = string
}
*/