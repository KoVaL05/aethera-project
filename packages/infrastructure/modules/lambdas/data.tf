data "aws_iam_policy_document" "basic_lambda_role" {
  statement {
    sid = "RoleForBasicLambdaOperations"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com"
      ]
    }
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "call_lambda_function_url" {
  statement {
    sid = "RoleForCallingLambdaFunctionUrl"
    actions = [
      "lambda:InvokeFunctionUrl"
    ]
    resources = [aws_lambda_function_url.create_vpc_endpoint_url.function_arn, aws_lambda_function_url.delete_vpc_endpoint_url.function_arn]
    effect    = "Allow"
  }

}

data "aws_region" "current" {}

data "aws_iam_group" "admin" {
  group_name = "Admin"
}

