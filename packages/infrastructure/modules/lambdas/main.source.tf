resource "aws_lambda_event_source_mapping" "lambda_dynamodb_trigger" {
  event_source_arn  = var.api_key_stream_arn
  function_name     = aws_lambda_function.lambda_output_functions["dynamodb_stream_handler"].arn
  starting_position = "LATEST"
}