resource "aws_cognito_user_pool" "default_user_pool" {
  name = "default"

  auto_verified_attributes = ["email"]
  alias_attributes         = ["email", "preferred_username"]
  deletion_protection      = "ACTIVE"

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "admin_only"
      priority = 1
    }
  }

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject        = "Your verification code"
    email_message        = "Your verification code is {####}. "
  }

  schema {
    attribute_data_type      = "String"
    name                     = "name"
    developer_only_attribute = false
    mutable                  = true
    required                 = true
    string_attribute_constraints {
      max_length = 50
      min_length = 1
    }
  }

  schema {
    attribute_data_type      = "String"
    name                     = "email"
    developer_only_attribute = false
    mutable                  = true
    required                 = true
    string_attribute_constraints {
      max_length = 50
      min_length = 1
    }
  }
  schema {
    attribute_data_type      = "String"
    name                     = "family_name"
    developer_only_attribute = false
    mutable                  = true
    required                 = true
    string_attribute_constraints {
      max_length = 50
      min_length = 1
    }
    //TODO lambda_config
  }
}

resource "aws_cognito_user_pool_client" "default_client" {
  name            = "client"
  user_pool_id    = aws_cognito_user_pool.default_user_pool.id
  generate_secret = false

  # allowed_oauth_flows_user_pool_client = true
  # allowed_oauth_flows                  = ["implicit"]
  # allowed_oauth_scopes                 = ["profile", "email", "openid"]

  explicit_auth_flows = ["ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_CUSTOM_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_USER_PASSWORD_AUTH"]

  supported_identity_providers = [aws_cognito_identity_provider.google_provider.provider_name]
  access_token_validity        = 10
  id_token_validity            = 10
  refresh_token_validity       = 5

  default_redirect_uri = "aethera://"
  callback_urls        = ["aethera://"]
  logout_urls          = ["aethera://"]

  read_attributes  = ["nickname", "profile", "picture", "email", "name", "family_name"]
  write_attributes = ["nickname", "profile", "picture", "email", "name", "family_name"]
  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }
}
