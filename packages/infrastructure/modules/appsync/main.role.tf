resource "aws_iam_role" "appsync_api_key_role" {
  name               = "appsync_api_key_role"
  assume_role_policy = data.aws_iam_policy_document.appsync_assume_role.json
}

resource "aws_iam_role" "appsync_lambda_role" {
  name               = "appsync_lambbda_role"
  assume_role_policy = data.aws_iam_policy_document.appsync_assume_role.json
}


resource "aws_iam_policy" "appsync_lambda_policy" {
  name   = format("appsync_lambda_invoke-%s", var.random_name)
  policy = data.aws_iam_policy_document.appsync_invoke_lambda.json
}


resource "aws_iam_role_policy_attachment" "appsync_lambda_invoke" {
  role       = aws_iam_role.appsync_lambda_role.name
  policy_arn = aws_iam_policy.appsync_lambda_policy.arn
}