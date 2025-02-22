data "aws_iam_policy_document" "dynamodb_stream_lambda_doc" {

  statement {
    sid = "RoleForLambdaLogs"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    effect = "Allow"
    resources = [
      "*"
    ]
  }

  statement {
    sid = "RoleForVPCManagement"
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface"
    ]
    effect = "Allow"
    resources = [
      "*"
    ]
  }
 
   statement {

      sid       = "RoleForDynamoDBApiKeyStream"
      actions   = ["dynamodb:DescribeStream", "dynamodb:GetRecords", "dynamodb:GetShardIterator", "dynamodb:ListStreams"]
      effect    = "Allow"
      resources = [var.api_key_stream_arn]
    
  }

  statement {

      sid       = "RoleForNotifyingAppSync"
      actions   = ["appsync:GraphQL"]
      effect    = "Allow"
      resources = [var.api_key_appsync_arn]
    
  }
}