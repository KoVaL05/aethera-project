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

resource "aws_lambda_event_source_mapping" "lambda_dynamodb_trigger" {
  event_source_arn  = var.api_key_stream_arn
  function_name     = var.lambda_functions["dynamodb_stream_handler"].arn
  starting_position = "LATEST"
}