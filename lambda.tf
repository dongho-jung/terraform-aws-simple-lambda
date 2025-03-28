locals {
  image_uri_default = "${aws_ecr_repository.this.repository_url}:${local.dir_sha}"
  events_cron = {
    for i, _ in aws_cloudwatch_event_rule.crons : "cron_${i}" => {
      principal  = "events.amazonaws.com"
      source_arn = aws_cloudwatch_event_rule.crons[i].arn
    }
  }
  events_alarm = {
    for i, _ in aws_cloudwatch_event_rule.alarms : "alarm_${i}" => {
      principal  = "events.amazonaws.com"
      source_arn = aws_cloudwatch_event_rule.alarms[i].arn
    }
  }
  allowed_triggers = merge(
    local.events_cron,
    local.events_alarm
  )
  runtime = replace(
    regex(
      "(?m:^FROM.*/(.+)$)",
      file("${path.cwd}/${var.path_to_dockerfile_dir}/Dockerfile")
      )[
      0
    ], ":", ""
  )
  platform_architecture_map = {
    "linux/amd64" = "x86_64"
    "linux/arm64" = "arm64"
  }
}

resource "aws_lambda_function" "this" {
  function_name = var.name
  description   = var.description

  package_type  = "Image"
  architectures = [local.platform_architecture_map[var.target_arch]]
  image_uri     = local.image_uri_default

  environment {
    variables = var.environment_variables
  }

  memory_size = var.memory_size
  timeout     = var.timeout

  role = var.iam_role_name == null ? one(aws_iam_role.this[*].arn) : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.iam_role_name}"

  vpc_config {
    subnet_ids         = [for s in data.aws_subnet.this : s.id]
    security_group_ids = data.aws_security_groups.this.ids
  }

  depends_on = [
    docker_image.this,
    null_resource.docker_push,
    aws_cloudwatch_log_group.this
  ]
}

resource "aws_lambda_function_url" "this" {
  count = var.create_lambda_function_url ? 1 : 0

  function_name      = aws_lambda_function.this.function_name
  authorization_type = "NONE"
}

resource "aws_lambda_function_event_invoke_config" "this" {
  function_name                = aws_lambda_function.this.function_name
  maximum_event_age_in_seconds = 60
  maximum_retry_attempts       = var.maximum_retry_attempts
}
