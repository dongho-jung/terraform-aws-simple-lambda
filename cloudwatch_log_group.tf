resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/lambda/${var.name}"
  retention_in_days = var.log_rentention_in_days
}
