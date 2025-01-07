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
