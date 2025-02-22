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
