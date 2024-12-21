resource "aws_iam_policy" "lambdas_bucket_access_role" {
  name   = format("lambdas-bucket-access-%s", var.random_name)
  policy = data.aws_iam_policy_document.lambdas_bucket_access_policy.json
}

resource "aws_iam_role_policy_attachment" "s3_role_attachment" {
  role       = aws_iam_role.github_assume_role_oicd.name
  policy_arn = aws_iam_policy.lambdas_bucket_access_role.arn
}
