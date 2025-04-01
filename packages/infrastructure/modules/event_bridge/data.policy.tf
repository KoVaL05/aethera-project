data "aws_iam_policy_document" "event_bridge_role_documents" {
  for_each = local.scheduler_configuration

  statement {
    sid = format("EventBridgeRoleDocument%s", var.random_name)
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = [
        "scheduler.amazonaws.com"
      ]
    }
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "event_bridge_lambda_policies" {
  for_each = local.scheduler_configuration

  statement {
    sid = format("InvokeLambdaFunction%s", var.random_name)
    actions = [
      "lambda:InvokeFunction"
    ]
    effect = "Allow"
    resources = [
      each.value.lambda.arn
    ]
  }
}