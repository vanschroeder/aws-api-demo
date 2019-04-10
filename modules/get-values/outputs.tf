output "function_name" {
  value = "${var.function_name}"
}

output "function_arn" {
  value = "${aws_lambda_function._.arn}"
}

output "api_path" {
  value = "${aws_api_gateway_resource._.path_part}"
}


