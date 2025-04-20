data "aws_s3_object" "object" {
  for_each = local.lambda_functions_data

  bucket = var.lambdas_bucket_name
  key    = format("%s/%s.zip", each.key, each.key)
}

data "aws_s3_object" "lambdas_output_object" {
  for_each = local.lambda_outputs_functions_data

  bucket = var.lambdas_bucket_name
  key    = format("%s/%s.zip", each.key, each.key)
}