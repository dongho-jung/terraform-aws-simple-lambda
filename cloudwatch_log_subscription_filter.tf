resource "aws_cloudwatch_log_subscription_filter" "this" {
  count = length(var.event_source_cloudwatch_log_subscription_filters)

  name = "${var.name}-log-subscription-filter-${count.index}"

  log_group_name = var.event_source_cloudwatch_log_subscription_filters[count.index].log_group_name

  filter_pattern = (
    var.event_source_cloudwatch_log_subscription_filters[count.index].filter_pattern != null
    ? var.event_source_cloudwatch_log_subscription_filters[count.index].filter_pattern
    : ""
  )
  destination_arn = aws_lambda_function.this.arn
}
