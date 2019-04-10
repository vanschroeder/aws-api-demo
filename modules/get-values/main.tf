# -- LAMBDA

data "archive_file" "_" {
  type        = "zip"
  source_dir = "lambda"
  output_path = "lambda/dist.zip"
}

# aws_lambda_function._
resource "aws_lambda_function" "_" {
  filename = "lambda/dist.zip"
  function_name = "${var.function_name}"
  role = "${var.role_arn}"
  handler = "handlers/${var.function_name}/index.handler"
  source_code_hash = "${data.archive_file._.output_base64sha256}"
  runtime = "nodejs8.10"
  timeout = 900
  memory_size = 512

  environment {
    variables = {
      INCREMENT = 50
    }
  }
}

# aws_api_gateway_resource._
resource "aws_api_gateway_resource" "_" {
  rest_api_id = "${var.api_id}"
  parent_id   = "${var.api_root_id}"
  path_part   = "${var.function_name}"
}

# aws_api_gateway_method._
resource "aws_api_gateway_method" "_" {
  rest_api_id   = "${var.api_id}"
  resource_id   = "${aws_api_gateway_resource._.id}"
  http_method   = "POST"
  authorization = "NONE"
}

# aws_api_gateway_integration._
resource "aws_api_gateway_integration" "_" {
  rest_api_id          = "${var.api_id}"
  resource_id          = "${aws_api_gateway_resource._.id}"
  http_method          = "${aws_api_gateway_method._.http_method}"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function._.arn}/invocations"
  integration_http_method = "POST"
  timeout_milliseconds = 29000
}


# -- OPTIONS end point for CORS

module "cors" {
  source = "github.com/squidfunk/terraform-aws-api-gateway-enable-cors"
  version = "0.2.0"

  api_id          = "${var.api_id}"
  api_resource_id = "${aws_api_gateway_resource._.id}"
}

resource "aws_lambda_permission" "_" {
  function_name = "${aws_lambda_function._.function_name}"
  statement_id = "AllowExecutionFromApiGateway"
  action = "lambda:InvokeFunction"
  principal = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${var.api_id}/*/${aws_api_gateway_integration._.integration_http_method}${aws_api_gateway_resource._.path}"
}


# -- Cloudwatch Logging for Lambda

# Logging Policy for Lambda Methods
resource "aws_iam_policy" "_" {
  name = "${var.function_name}-iam-policy"
  path = "/"
  description = "IAM policy for logging from lambda executions"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Attaches Policy to crypto lambdas role
resource "aws_iam_role_policy_attachment" "_" {
  role = "${var.role_name}"
  policy_arn = "${aws_iam_policy._.arn}"
}
