module "simple_lambda" {
   source  = "dongho-jung/simple-lambda/aws"
   version = "~> 1.0.0"

   name = "simple-lambda-python-uv"
   description = "simple lambda using python uv"

   using_uv = true
}
