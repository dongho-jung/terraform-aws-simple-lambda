# WHAT?
A terraform module for Simple Lambda deployment

# WHEN?
- When you want to use a runtime not supported by the Serverless Framework (e.g. Python 3.11↑)
- When you don't have time to troubleshoot Serverless Framework issues and documentation
- When you need to deploy a Simple Lambda without the CloudFormation headache
- When you're tired of setting up ECR, CloudWatch, Docker Image, and other resources manually with Terraform

# WHY?
1. **No additional installations or updates required**
2. **Straightforward Deployment Process:**
    - Preview plan with `terraform plan`
    - Deploy with `terraform apply`
    - No confusion over deployment options
3. **AWS SSO Support:** Use AWS SSO locally without extra setup. Unlike the Serverless Framework, this module has built-in AWS SSO support
4. **Efficient Package Management with Docker Layers:** Automatically leverages Docker Layer caching without additional plugins or configurations (e.g. no need for `serverless-python-requirements` or slim/strip settings)
5. **Automatic File Change Detection:** Detects changes in the caller working directory and builds/deploys only when necessary
6. **Easy Scheduler Integration:** Add Lambda schedulers effortlessly with `schedule_cron` (e.g. `schedule_cron` = `0 0 * * ? *`)
7. **Transparent Resource Changes:** Terraform's plan output makes it easy to understand why resources are created, modified, or deleted, unlike CloudFormation
8. **Tag Management Made Simple:** Leverages Terraform AWS Provider's default tag functionality, removing the need for plugins like `serverless-plugin-resource-tagging`
9. **Comprehensive Resource Definitions:** Defines ECR Repository, CloudWatch Event, CloudWatch Logs LogGroup, Docker Image, and other resources when deploying Lambda
10. **No Limitations with Size:** Deployment package size is limited to 50MB(unzipped 250MB), meanwhile, the Docker Image size is limited to 10GB

# EXAMPLES
## 1. [Minimum Configuration](https://github.com/dongho-jung/terraform-aws-simple-lambda/blob/main/examples/minimum/main.tf)
```terraform
module "simple_lambda" {
   source  = "dongho-jung/simple-lambda/aws"
   version = "~> 1.0.0"
   
   name = "simple-lambda"
   description = "simple lambda"
}
```

## 2. [Scheduling With Cron](https://github.com/dongho-jung/terraform-aws-simple-lambda/blob/main/examples/cron/main.tf)
```terraform
module "simple_lambda" {
   source  = "dongho-jung/simple-lambda/aws"
   version = "~> 1.0.0"
   
   name = "simple-lambda-cron"
   description = "simple lambda with scheduling with cron"
   
   event_source_crons = ["35 0 ? * * *"]  # KST 09:35 Daily
}
```

## 3. [Mapping With Cloudwatch Alarm](https://github.com/dongho-jung/terraform-aws-simple-lambda/blob/main/examples/cloudwatch-alarm/main.tf)
```terraform
module "simple_lambda" {
   source  = "dongho-jung/simple-lambda/aws"
   version = "~> 1.0.0"
   
   name = "simple-lambda-cloudwatch-alarm"
   description = "simple lambda mapping with cloudwatch alarm"
   
   event_source_cloudwatch_alarm_names = [
      "ecs/main/worker-cpu-utilization-high",
   ]
}
```

## 4. [Extra Permissions](https://github.com/dongho-jung/terraform-aws-simple-lambda/blob/main/examples/extra-permissions/main.tf)
```terraform
module "simple_lambda" {
   source  = "dongho-jung/simple-lambda/aws"
   version = "~> 1.0.0"
   
   name = "simple-lambda-extra-permissions"
   description = "simple lambda with extra permissions"
   
   iam_role_name = "monitoring-elasticsearch"
   iam_policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"]
   iam_statements = [
      {
         actions = [
            "s3:Get*",
            "s3:Describe*",
            "s3:List*"
         ]
         resources = ["*"]
      }
   ]
}
```

## 5. [Using Python uv](https://github.com/dongho-jung/terraform-aws-simple-lambda/blob/main/examples/python-uv/main.tf)
```terraform
module "simple_lambda" {
   source  = "dongho-jung/simple-lambda/aws"
   version = "~> 1.0.0"
   
   name = "simple-lambda-python-uv"
   description = "simple lambda using python uv"
   
   using_uv = true
}
```
