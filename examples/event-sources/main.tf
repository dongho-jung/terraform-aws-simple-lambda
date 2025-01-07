module "simple_lambda" {
  source  = "dongho-jung/simple-lambda/aws"
  version = "~> 1.0.0"

  name        = "simple-lambda-event-sources"
  description = "simple lambda with events sources"

  event_source_event_bridges = [
    {
      source = "aws.ecs"
      detail_types = [
        "ECS Deployment State Change",
        "ECS Task State Change"
      ]
    },
    {
      source = "aws.rds"
      detail_types = [
        "RDS DB Instance Event"
      ]
    },
    {
      source = "aws.health"
      detail_types = [
        "AWS Health Event"
      ]
    },
    {
      source = "aws.ssm"
      detail_types = [
        "AWS API Call via CloudTrail"
      ]
    },
    {
      source = "aws.ec2"
      detail_types = [
        "EC2 Spot Instance Interruption Warning"
      ]
    }
  ]
}
