output "api_url" {
  value = "${aws_api_gateway_deployment._.invoke_url}"
}

output "get-values endpoint" {
  value = "${aws_api_gateway_deployment._.invoke_url}${var.stage_name}/${module.get-values.api_path}"
}

output "webiste-url" {
  value = "http://${aws_s3_bucket._.website_endpoint}"
}

output "sync command" {
  value = "npm run build-web ; aws s3 sync web/dist s3://${aws_s3_bucket._.id}"
}
