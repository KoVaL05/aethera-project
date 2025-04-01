variable "random_name" {
  type = string
}

variable "lambda_functions" {
  type = map(object(
    {
      arn : string
      function_name : string
    }
  ))
}