data "aws_iam_policy_document" "api_key_table_access" {
  statement {
    effect = "Allow"

    actions = [
      "dynamodb:*"
    ]

    resources = [
      format("%s/*", var.api_key_table_arn),
      var.api_key_table_arn
    ]
  }
}
