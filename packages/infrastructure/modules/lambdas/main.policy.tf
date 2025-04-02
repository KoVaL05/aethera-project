resource "aws_iam_group_policy" "admin_policy" {
  name   = "admin_policy"
  group  = data.aws_iam_group.admin.group_name
  policy = data.aws_iam_policy_document.call_lambda_function_url.json
}