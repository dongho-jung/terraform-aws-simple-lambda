locals {
  do_create_role = (
  (var.iam_role_name == null) && (
  (var.iam_statements != []) || (var.iam_policy_arns != [])
  )
  )

  iam_policy_arns = (
    var.vpc_subnet_names != []
    ? concat(["arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"], var.iam_policy_arns)
    : var.iam_policy_arns
  )
}

resource "aws_iam_role" "this" {
  count = local.do_create_role ? 1 : 0

  name = var.name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "this" {
  count = length(var.iam_statements) > 0 ? 1 : 0

  name = var.name
  role = one(aws_iam_role.this[*].id)
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = var.iam_statements
  })
}

resource "aws_iam_role_policy_attachment" "additional" {
  for_each = toset(local.iam_policy_arns)

  role = one(aws_iam_role.this[*].name)
  policy_arn = each.value
}
