data "aws_s3_object" "object" {
  for_each = local.lambda_functions_data

  bucket = var.lambdas_bucket_name
  key    = format("%s/%s.zip", each.key, each.key)
  etag = filemd5(format(format("%s/%s.zip", each.key, each.key)))
}
