resource "aws_cloudwatch_event_rule" "crons" {
  count = length(var.event_source_crons)

  name                = "${var.name}-cron-${count.index}"
  schedule_expression = "cron(${var.event_source_crons[count.index]})"
}

resource "aws_cloudwatch_event_rule" "alarms" {
  count = length(var.event_source_cloudwatch_alarm_names) > 0 ? 1 : 0

  name = "${var.name}-alarm"
  event_pattern = jsonencode({
    "source" : [
      "aws.cloudwatch"
    ],
    "detail-type" : [
      "CloudWatch Alarm State Change"
    ],
    "resources" : [
      for i, v in var.event_source_cloudwatch_alarm_names :
      "arn:aws:cloudwatch:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:alarm:${var.event_source_cloudwatch_alarm_names[i]}"
    ]
  })
}

resource "aws_cloudwatch_event_rule" "event_bridges" {
  count = length(var.event_source_event_bridges)

  name = "${var.name}-event-bridge-${count.index}"
  event_pattern = jsonencode({
    "source" : [
      var.event_source_event_bridges[count.index].source
    ],
    "detail-type" : var.event_source_event_bridges[count.index].detail_types
  })
}
