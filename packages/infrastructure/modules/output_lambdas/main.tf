data "aws_s3_object" "dynamodb_stream_lambda_object" {
  bucket = var.lambdas_bucket_name
  key    = "dynamodb_stream_handler-lambda/dynamodb_stream_handler-lambda.zip"
}


resource "aws_iam_role" "dynamodb_stream_handler_role" {
  name               = format("dynamodb_stream_handler-lambda-role-%s", var.random_name)
  assume_role_policy = data.aws_iam_policy_document.basic_lambda_role.json
}

resource "aws_lambda_function" "dynamodb_stream_handler_function" {
  function_name = format("dynamodb_stream_handler_%s", var.random_name)
  role          = aws_iam_role.dynamodb_stream_handler_role.arn
  runtime       = "python3.13"
  timeout       = 60
  memory_size   = 128
  publish       = true

  handler   = "index.handler"
  s3_bucket = var.lambdas_bucket_name
  s3_key    = data.aws_s3_object.dynamodb_stream_lambda_object.key

  source_code_hash = data.aws_s3_object.dynamodb_stream_lambda_object.etag

  environment {
      variables = {
        apiKeyApiUrl = var.api_key_public_appsync_uri
      }
  }
}

resource "aws_lambda_event_source_mapping" "lambda_dynamodb_trigger" {
  event_source_arn  = var.api_key_stream_arn
  function_name     = aws_lambda_function.dynamodb_stream_handler_function.arn
  starting_position = "LATEST"
}
