resource "aws_lambda_permission" "crons" {
  count = length(var.event_source_crons)

  statement_id  = "AllowExecutionFromCloudWatchCronEvents-${count.index}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.crons[count.index].arn
}

resource "aws_lambda_permission" "alarms" {
  count = length(var.event_source_cloudwatch_alarm_names)

  statement_id  = "AllowExecutionFromCloudWatchAlarmEvents-${count.index}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "events.amazonaws.com"
  source_arn    = one(aws_cloudwatch_event_rule.alarms[*].arn)
}

resource "aws_lambda_permission" "event_bridges" {
  count = length(var.event_source_event_bridges)

  statement_id  = "AllowExecutionFromEventBridgeEvents-${count.index}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.event_bridges[count.index].arn
}

resource "aws_lambda_permission" "cloudwatch_log_subscription_filters" {
  count = length(var.event_source_cloudwatch_log_subscription_filters) > 0 ? 1 : 0

  statement_id  = "AllowExecutionFromCloudWatchLogSubscriptionFilters"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "logs.${data.aws_region.current.name}.amazonaws.com"
  source_arn    = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:*:*"
}

resource "aws_lambda_permission" "sns_topics" {
  count = length(var.event_source_sns_topics)

  statement_id  = "AllowExecutionFromSns-${count.index}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = var.event_source_sns_topics[count.index]
}
