resource "aws_iam_role" "appsync_api_key_role" {
  name               = "appsync_api_key_role"
  assume_role_policy = data.aws_iam_policy_document.appsync_assume_role.json
}

resource "aws_iam_role" "appsync_public_lambda_role" {
  name               = "appsync_public_lambbda_role"
  assume_role_policy = data.aws_iam_policy_document.appsync_assume_role.json
}

resource "aws_iam_role" "appsync_private_lambda_role" {
  name               = "appsync_private_lambbda_role"
  assume_role_policy = data.aws_iam_policy_document.appsync_assume_role.json
}


resource "aws_iam_policy" "appsync_public_lambda_policy" {
  name   = format("appsync_public_lambda_invoke-%s", var.random_name)
  policy = data.aws_iam_policy_document.appsync_public_invoke_lambda.json
}


resource "aws_iam_role_policy_attachment" "appsync_public_lambda_invoke" {
  role       = aws_iam_role.appsync_public_lambda_role.name
  policy_arn = aws_iam_policy.appsync_public_lambda_policy.arn
}

resource "aws_iam_policy" "appsync_private_lambda_policy" {
  name   = format("appsync_private_lambda_invoke-%s", var.random_name)
  policy = data.aws_iam_policy_document.appsync_invoke_lambda.json
}


resource "aws_iam_role_policy_attachment" "appsync_private_lambda_invoke" {
  role       = aws_iam_role.appsync_private_lambda_role.name
  policy_arn = aws_iam_policy.appsync_private_lambda_policy.arn
}