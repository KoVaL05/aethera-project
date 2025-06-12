resource "aws_iam_policy" "lambda_policies" {
  for_each = var.lambda_functions

  name   = format("%s-lambda-policy-%s", each.key, var.random_name)
  policy = data.aws_iam_policy_document.lambda_policies[each.key].json
}

resource "aws_iam_role_policy_attachment" "lambdas_role_attachment" {
  for_each = var.lambda_functions

  role       = each.value.iam_role_name
  policy_arn = aws_iam_policy.lambda_policies[each.key].arn
}

resource "aws_iam_policy" "lambda_output_policies" {
  for_each = var.lambda_output_functions

  name   = format("%s-lambda-output-policy-%s", each.key, var.random_name)
  policy = data.aws_iam_policy_document.lambda_policies[each.key].json
}

resource "aws_iam_role_policy_attachment" "lambdas_output_role_attachment" {
  for_each = var.lambda_output_functions

  role       = each.value.iam_role_name
  policy_arn = aws_iam_policy.lambda_output_policies[each.key].arn
}