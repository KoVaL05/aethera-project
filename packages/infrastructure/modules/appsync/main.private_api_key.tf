resource "aws_appsync_graphql_api" "api_key_private" {
  name                = "API_Key_Private"
  authentication_type = "AWS_IAM"


  schema               = data.local_file.api_key_private_schema.content
  query_depth_limit    = 2
  introspection_config = "DISABLED"
  visibility           = "PRIVATE"
}

resource "aws_appsync_datasource" "api_key_table_private" {
  name = "api_key_table_private"
  type = "AMAZON_DYNAMODB"

  api_id           = aws_appsync_graphql_api.api_key_public.id
  service_role_arn = aws_iam_role.appsync_api_key_role.arn

  dynamodb_config {
    table_name = var.api_key_table_name
  }
}

resource "aws_appsync_datasource" "create_api_key_private_lambda" {
  name = "create_api_key_private_lambda"
  type = "AWS_LAMBDA"

  api_id           = aws_appsync_graphql_api.api_key_private.id
  service_role_arn = aws_iam_role.appsync_lambda_role.arn

  lambda_config {
    function_arn = var.lambda_functions["create_api_key_private"].arn
  }
}

resource "aws_appsync_datasource" "update_api_key_private_lambda" {
  name = "update_api_key_private_lambda"
  type = "AWS_LAMBDA"

  api_id           = aws_appsync_graphql_api.api_key_private.id
  service_role_arn = aws_iam_role.appsync_lambda_role.arn

  lambda_config {
    function_arn = var.lambda_functions["update_api_key_private"].arn
  }
}