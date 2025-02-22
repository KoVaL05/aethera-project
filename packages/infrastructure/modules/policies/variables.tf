variable "random_name" {
  type = string
}

variable "lambdas_bucket_arn" {
  type = string
}

variable "lambda_functions" {
  type = map(object({
    iam_role_name : string
    permissions : map(any)
  }))
}

variable "user_pool_arn" {
  type = string
}

variable "secret_manager_sns_arn" {
  type = string
}

variable "api_key_appsync_arn" {
  type = string
}

variable "api_key_table_arn" {
  type = string
}

variable "api_key_stream_arn" {
  type = string
}
variable "appsync_role_id" {
  type = string
}

variable "kms_api_key_arn" {
  type = string
}