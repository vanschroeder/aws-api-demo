variable "namespace" {
  type="string"
  default="aws-api-demo"
}

variable "region" {
  type="string"
  default = "us-east-1"
}

variable "stage_name" {
  type="string"
  default = "api-demo"
}

data "aws_caller_identity" "current" {}
