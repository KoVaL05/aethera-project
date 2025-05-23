data "aws_iam_policy_document" "lambda_policies" {
  for_each = var.lambda_functions

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

  dynamic "statement" {
    for_each = each.value.permissions.link_users ? [each.key] : []

    content {
      sid = "RoleForLinkingUsers"
      actions = [
        "cognito-idp:ListUsers",
        "cognito-idp:AdminLinkProviderForUser",
        "cognito-idp:AdminCreateUser",
        "cognito-idp:AdminSetUserPassword"
      ]
      effect = "Allow"
      resources = [
        format("arn:aws:cognito-idp:%s:%s:userpool/%s", data.aws_region.current.name, data.aws_caller_identity.current.account_id, var.user_pool_arn)
      ]
    }
  }

  dynamic "statement" {
    for_each = each.value.permissions.api_key_table == "write" ? [each.key] : []

    content {
      sid = "RoleForWritingApiKeys"
      actions = [
        "dynamodb:PutItem",
        "dynamodb:UpdateItem"
      ]
      effect = "Allow"
      resources = [
        format("%s/*", var.api_key_table_arn),
        var.api_key_table_arn
      ]
    }
  }

  dynamic "statement" {
    for_each = each.value.permissions.api_key_table == "delete" ? [each.key] : []

    content {
      sid = "RoleForDeletingApiKeys"
      actions = [
        "dynamodb:DeleteItem",
      ]
      effect = "Allow"
      resources = [
        format("%s/*", var.api_key_table_arn),
        var.api_key_table_arn
      ]
    }
  }

  dynamic "statement" {
    for_each = each.value.permissions.kms_api_key == "encrypt" ? [each.key] : []

    content {
      sid       = "RoleForApiKeyEncryption"
      actions   = ["kms:Encrypt"]
      effect    = "Allow"
      resources = [var.kms_api_key_arn]
    }
  }

  dynamic "statement" {
    for_each = each.value.permissions.api_key_stream ? [each.key] : []

    content {
      sid       = "RoleForDynamoDBApiKeyStream"
      actions   = ["dynamodb:DescribeStream", "dynamodb:GetRecords", "dynamodb:GetShardIterator", "dynamodb:ListStreams"]
      effect    = "Allow"
      resources = [var.api_key_stream_arn]
    }
  }

  dynamic "statement" {
    for_each = each.value.permissions.call_api_key_appsync ? [each.key] : []

    content {
      sid       = "RoleForNotifyingAppSync"
      actions   = ["appsync:GraphQL"]
      effect    = "Allow"
      resources = [var.api_key_appsync_arn]
    }
  }

  dynamic "statement" {
    for_each = each.value.permissions.vpc_endpoint == "create" ? [each.key] : []

    content {
      sid = "RoleForCreatingVpcEndpoint"
      actions = ["ec2:CreateVpcEndpoint",
        "ec2:DescribeVpcEndpoints",
      ]
      effect    = "Allow"
      resources = ["*"]
    }
  }

  dynamic "statement" {
    for_each = each.value.permissions.vpc_endpoint == "delete" ? [each.key] : []

    content {
      sid = "RoleForCreatingVpcEndpoint"
      actions = ["ec2:DeleteVpcEndpoints",
        "ec2:DescribeVpcEndpoints",
      ]
      effect    = "Allow"
      resources = ["*"]
    }
  }
}