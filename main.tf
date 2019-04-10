provider "aws" {
  region = "${var.region}"
}

# -- IAM Role
# Role for Lambdas
resource "aws_iam_role" "_" {
  name = "${var.namespace}-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

# -- Website

# data.template_file._.rendered
data "template_file" "_" {
  template = "${file("${path.module}/policies/website-bucket.json")}"

  vars {
    bucket = "${data.aws_caller_identity.current.account_id}-${var.namespace}-${var.stage_name}"
  }
}

resource "aws_s3_bucket" "_" {
  bucket = "${data.aws_caller_identity.current.account_id}-${var.namespace}-${var.stage_name}"
  acl    = "private"
  policy = "${data.template_file._.rendered}"
  force_destroy = true
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

# -- API Gateway

# aws_api_gateway_rest_api._
resource "aws_api_gateway_rest_api" "_" {
  name = "${var.namespace}"
}

# aws_api_gateway_resource._
resource "aws_api_gateway_resource" "_" {
  rest_api_id = "${aws_api_gateway_rest_api._.id}"
  parent_id   = "${aws_api_gateway_rest_api._.root_resource_id}"
  path_part   = "identity"
}

# aws_api_gateway_deployment._
resource "aws_api_gateway_deployment" "_" {
  rest_api_id = "${aws_api_gateway_rest_api._.id}"
  stage_name  = ""

  # Hack: force deployment on source code hash change
  variables = {
    "source_code_hash" = "${sha256(file("lambda/dist.zip"))}"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    "module.get-values",
  ]
}

# aws_api_gateway_stage._
resource "aws_api_gateway_stage" "_" {
  stage_name    = "${var.stage_name}"
  rest_api_id   = "${aws_api_gateway_rest_api._.id}"
  deployment_id = "${aws_api_gateway_deployment._.id}"
}

module "get-values" {
  source = "modules/get-values"
  function_name = "get-values"
  region    = "${var.region}"
  role_arn = "${aws_iam_role._.arn}"
  role_name = "${aws_iam_role._.name}"
  lambda_filename = "lambda/dist.zip"
  stage_name = "${var.stage_name}"
  api_id = "${aws_api_gateway_rest_api._.id}"
  api_root_id = "${aws_api_gateway_rest_api._.root_resource_id}"
}
