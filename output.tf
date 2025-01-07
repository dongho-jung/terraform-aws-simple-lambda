output "lambda_arn" {
  value       = aws_lambda_function.this.arn
  description = "ARN of lambda function"
}

output "image_tag" {
  value       = docker_image.this.repo_digest
  description = "Image tag of pushed docker image"
}

output "lambda_function_url" {
  value       = one(aws_lambda_function_url.this[*].function_url)
  description = "URL of lambda function, if created"
}


output "iam_role_arn" {
  value       = one(aws_iam_role.this[*].arn)
  description = "ARN of IAM role for lambda function, if created"
}
