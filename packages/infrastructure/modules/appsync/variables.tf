variable "user_pool_id" {
  type = string
}

variable "api_key_table_name" {
  type = string
}

variable "lambda_functions" {
  type = map(object({
    arn : string
  }))
}

variable "random_name" {
  type = string
}
