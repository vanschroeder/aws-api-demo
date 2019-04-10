variable "region" {
  type = "string"
}

variable "function_name" {
  type = "string"
}

variable "role_arn" {
  type = "string"
}

variable "role_name" {
  type = "string"
}


variable "lambda_filename" {
  type = "string"
}

variable "api_id" {
  type="string"
}

variable "api_root_id" {
  type="string"
}

variable "stage_name" {
  type = "string"
}

data "aws_caller_identity" "current" {}

