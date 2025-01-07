module "simple_lambda" {
   source  = "dongho-jung/simple-lambda/aws"
   version = "~> 1.0.0"

   name = "simple-lambda-cron"
   description = "simple lambda with scheduling with cron"

   event_source_crons = ["35 0 ? * * *"]  # KST 09:35 Daily
}
