#ALB details for backend servers (Nakama service included)
variable "application_alb" {
 type         = string
 default      = "cf-application-alb"
 description  = "alb for application server"
}

# variable "new" {
#  type         = string
#  default      = ""
#  description  = "alb for application server"
# }

# variable "certificate_arn" {
#   type        = string
#   default     = "arn:aws:acm:ap-south-1:876529261348:certificate/893743f6-2af1-44de-b02f-fd012a99ad35"
#   description = "ACM certificate for application alb listner"
# }

variable "env" {
  default = "test"
}

variable "vpc_id" {
  type = string
}

variable "public1_subnet" {
  type = string
}

variable "public2_subnet" {
  type = string
}
