resource "aws_iam_role" "this" {
  count = (length(var.iam_statements) > 0) || (length(var.iam_policy_arns) > 0) ? 1 : 0

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
  for_each = toset(var.iam_policy_arns)

  role       = one(aws_iam_role.this[*].name)
  policy_arn = each.value
}
