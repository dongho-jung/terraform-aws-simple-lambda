module "simple_lambda" {
   source  = "dongho-jung/simple-lambda/aws"
   version = "~> 1.0.0"

   name = "simple-lambda-cloudwatch-alarm"
   description = "simple lambda mapping with cloudwatch alarm"

   event_source_cloudwatch_alarm_names = [
      "ecs/main/worker-cpu-utilization-high",
   ]
}
