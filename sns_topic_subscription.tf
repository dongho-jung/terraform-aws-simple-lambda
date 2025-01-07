resource "aws_sns_topic_subscription" "sns_topics" {
  count = length(var.event_source_sns_topics)

  topic_arn = var.event_source_sns_topics[count.index]
  protocol  = "lambda"
  endpoint  = aws_lambda_function.this.arn
}
