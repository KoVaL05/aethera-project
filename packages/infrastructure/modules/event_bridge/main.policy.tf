resource "aws_iam_role" "event_bridge_roles" {
  for_each = local.scheduler_configuration

  name               = format("event-bridge-role_%s_%s", each.key, var.random_name)
  assume_role_policy = data.aws_iam_policy_document.event_bridge_role_documents[each.key].json
}

resource "aws_iam_policy" "event_bridge_lambda_policies" {
  for_each = local.scheduler_configuration

  name   = format("%s_event_bridge_lambda_policy_%s", each.key, var.random_name)
  policy = data.aws_iam_policy_document.event_bridge_lambda_policies[each.key].json
}

resource "aws_iam_role_policy_attachment" "event_bridge_lambda_role_attachments" {
  for_each = local.scheduler_configuration

  role       = aws_iam_role.event_bridge_roles[each.key].name
  policy_arn = aws_iam_policy.event_bridge_lambda_policies[each.key].arn
}