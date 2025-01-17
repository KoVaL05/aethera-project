data "aws_iam_policy_document" "appsync_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["appsync.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "appsync_invoke_lambda" {
  statement {
    effect = "Allow"

    actions = ["lambda:InvokeFunction"]

    resources = [var.lambda_functions["create_api_key"].arn, var.lambda_functions["update_api_key"].arn,var.lambda_functions["delete_api_key"].arn]
  }
}