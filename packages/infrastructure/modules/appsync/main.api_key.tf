resource "aws_appsync_graphql_api" "api_key_public" {
  name                = "API_Key_Public"
  authentication_type = "AMAZON_COGNITO_USER_POOLS"

  user_pool_config {
    aws_region   = data.aws_region.current.name
    user_pool_id = var.user_pool_id

    default_action = "ALLOW"
  }

  schema               = data.local_file.api_key_schema.content
  query_depth_limit    = 2
  introspection_config = "DISABLED"
}

resource "aws_appsync_datasource" "api_key_table" {
  name = "api_key_table"
  type = "AMAZON_DYNAMODB"

  api_id           = aws_appsync_graphql_api.api_key_public.id
  service_role_arn = aws_iam_role.appsync_api_key_role.arn

  dynamodb_config {
    table_name = var.api_key_table_name
  }
}

resource "aws_appsync_datasource" "create_api_key_lambda" {
  name = "create_api_key_lambda"
  type = "AWS_LAMBDA"

  api_id           = aws_appsync_graphql_api.api_key_public.id
  service_role_arn = aws_iam_role.appsync_lambda_role.arn

  lambda_config {
    function_arn = var.lambda_functions["create_api_key"].arn
  }
}

resource "aws_appsync_datasource" "update_api_key_lambda" {
  name = "update_api_key_lambda"
  type = "AWS_LAMBDA"

  api_id           = aws_appsync_graphql_api.api_key_public.id
  service_role_arn = aws_iam_role.appsync_lambda_role.arn

  lambda_config {
    function_arn = var.lambda_functions["update_api_key"].arn
  }
}

resource "aws_appsync_datasource" "delete_api_key_lambda" {
  name = "delete_api_key_lambda"
  type = "AWS_LAMBDA"

  api_id           = aws_appsync_graphql_api.api_key_public.id
  service_role_arn = aws_iam_role.appsync_lambda_role.arn

  lambda_config {
    function_arn = var.lambda_functions["delete_api_key"].arn
  }
}

resource "aws_appsync_datasource" "default_datasource" {
  name = "default_data_source"
  type = "NONE"

  api_id = aws_appsync_graphql_api.api_key_public.id
}