resource "aws_iam_policy" "dynamodb_stream_lambda_policies" {

  name   = format("dynamodb_stream_lambda-lambda-policy-%s", var.random_name)
  policy = data.aws_iam_policy_document.dynamodb_stream_lambda_doc.json
}

resource "aws_iam_role_policy_attachment" "dynamodb_stream_handler_role_attachment" {
  role       = aws_iam_role.dynamodb_stream_handler_role.name
  policy_arn = aws_iam_policy.dynamodb_stream_lambda_policies.arn
}
