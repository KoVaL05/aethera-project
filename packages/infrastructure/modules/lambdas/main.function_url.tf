resource "aws_lambda_function_url" "create_vpc_endpoint_url" {
  function_name      = aws_lambda_function.lambda_functions["create_vpc_endpoint"].function_name
  authorization_type = "AWS_IAM"
}

resource "aws_lambda_function_url" "delete_vpc_endpoint_url" {
  function_name      = aws_lambda_function.lambda_functions["delete_vpc_endpoint"].function_name
  authorization_type = "AWS_IAM"
}