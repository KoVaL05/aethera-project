module "random" {
  source = "./modules/random"
}
module "bedrock" {
  source                 = "./modules/bedrock"
  random_name            = module.random.random_name
  subject_agent_role_arn = module.policies.subject_agent_role_arn
}

module "action_groups" {
  source             = "./modules/action-groups"
  subject_agent_id   = module.bedrock.subject_agent_id
  subject_lambda_arn = module.lambdas.lambda_functions["subject_group_executor"].arn
}

module "kms" {
  source = "./modules/kms"
}

module "dynamodb" {
  source      = "./modules/dynamodb"
  random_name = module.random.random_name
}
module "lambdas" {
  source              = "./modules/lambdas"
  random_name         = module.random.random_name
  lambdas_bucket_arn  = module.s3.lambdas_bucket_arn
  lambdas_bucket_name = module.s3.lambda_bucket_name
  kms_api_key_alias   = module.kms.kms_api_key_alias_name
  api_key_table_name  = module.dynamodb.api_key_table_name
}

module "s3" {
  source      = "./modules/s3"
  random_name = module.random.random_name
}


module "cognito" {
  source = "./modules/cognito"

  random_name           = module.random.random_name
  gcp_web_client_id     = var.gcp_web_client_id
  gcp_web_client_secret = var.gcp_web_client_secret
  lambda_functions      = module.lambdas.lambda_functions
}


module "appsync" {
  source             = "./modules/appsync"
  user_pool_id       = module.cognito.user_pool_id
  api_key_table_name = module.dynamodb.api_key_table_name
  lambda_functions   = module.lambdas.lambda_functions
  random_name        = module.random.random_name
}

module "secrets_manager" {
  source = "./modules/secrets_manager"
  aethera_app_secret = { userPoolId = module.cognito.user_pool_id
  clientPoolId = module.cognito.user_pool_id }

}

module "policies" {
  source                 = "./modules/policies"
  random_name            = module.random.random_name
  lambdas_bucket_arn     = module.s3.lambdas_bucket_arn
  lambda_functions       = module.lambdas.lambda_functions
  user_pool_arn          = module.cognito.user_pool_arn
  secret_manager_sns_arn = module.secrets_manager.secret_manager_sns_arn
  api_key_appsync_arn    = module.appsync.api_key_appsync_arn
  api_key_table_arn      = module.dynamodb.api_key_table_arn
  appsync_role_id        = module.appsync.appsync_role_id
  kms_api_key_arn        = module.kms.kms_api_key_arn
  api_key_stream_arn = module.dynamodb.api_key_stream_arn
}
