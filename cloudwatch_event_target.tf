resource "aws_cloudwatch_event_target" "crons" {
  count = length(var.event_source_crons)

  rule = aws_cloudwatch_event_rule.crons[count.index].name
  arn  = aws_lambda_function.this.arn
}

resource "aws_cloudwatch_event_target" "alarms" {
  count = length(var.event_source_cloudwatch_alarm_names) > 0 ? 1 : 0

  rule = one(aws_cloudwatch_event_rule.alarms[*].name)
  arn  = aws_lambda_function.this.arn
}

resource "aws_cloudwatch_event_target" "event_bridges" {
  count = length(var.event_source_event_bridges)

  rule = aws_cloudwatch_event_rule.event_bridges[count.index].name
  arn  = aws_lambda_function.this.arn
}
