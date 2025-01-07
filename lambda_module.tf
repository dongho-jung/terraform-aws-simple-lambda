# locals {
#   image_uri_default = "${aws_ecr_repository.this.repository_url}:${local.current_time}"
#   events_cron = {
#     for i, _ in aws_cloudwatch_event_rule.crons : "cron_${i}" => {
#       principal  = "events.amazonaws.com"
#       source_arn = aws_cloudwatch_event_rule.crons[i].arn
#     }
#   }
#   events_alarm = {
#     for i, _ in aws_cloudwatch_event_rule.alarms : "alarm_${i}" => {
#       principal  = "events.amazonaws.com"
#       source_arn = aws_cloudwatch_event_rule.alarms[i].arn
#     }
#   }
#   allowed_triggers = merge(
#     local.events_cron,
#     local.events_alarm
#   )
#   runtime = replace(
#     regex(
#       "(?m:^FROM.*/(.+)$)",
#       file("${path.cwd}/${var.path_to_dockerfile_dir}/Dockerfile")
#     )[
#     0
#     ], ":", ""
#   )
#   platform_architecture_map = {
#     "linux/amd64" = "x86_64"
#     "linux/arm64" = "arm64"
#   }
# }

# module "lambda" {
#   source = "terraform-aws-modules/lambda/aws"

#   runtime = local.runtime

#   function_name = var.name
#   description   = var.description

#   create_package = false
#   image_uri      = local.image_uri_default
#   package_type   = "Image"
#   architectures = [local.platform_architecture_map[var.target_arch]]

#   create_role = var.iam_role_name == null ? true : false
#   lambda_role = var.iam_role_name == null ? null : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.iam_role_name}"

#   allowed_triggers                          = local.allowed_triggers
#   create_unqualified_alias_allowed_triggers = true
#   create_current_version_allowed_triggers   = false

#   vpc_subnet_ids         = [for s in data.aws_subnet.this : s.id]
#   vpc_security_group_ids = data.aws_security_groups.this.ids

#   environment_variables = var.environment_variables

#   maximum_retry_attempts = var.maximum_retry_attempts
#   timeout                = var.timeout

#   memory_size = var.memory_size

#   create_lambda_function_url = var.create_lambda_function_url

#   # need for maximum_retry_attempts. https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/594
#   create_async_event_config = true
#   # need for https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/263
#   create_unqualified_alias_async_event_config = false

#   depends_on = [
#     docker_image.this,
#     null_resource.docker_push
#   ]
# }
