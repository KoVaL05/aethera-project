locals {
  lambda_functions_data = {
    "subject_group_executor" = {
      allow_agent_execution    = true
      allow_userpool_execution = false
      permissions = {
        link_users    = false
        api_key_table = "none"
        kms_api_key   = "none"
      },
      env = {}
    },
    "pre_signup" = {
      allow_agent_execution    = false
      allow_userpool_execution = true
      permissions = {
        link_users    = true
        api_key_table = "none"
        kms_api_key   = "none"
      },
      env = {}
    },
    "create_api_key" = {
      allow_agent_execution    = false
      allow_userpool_execution = false

      permissions = {
        link_users    = false
        api_key_table = "write"
        kms_api_key   = "encrypt"
      },
      env = {
        kmsApiKeyAliasName = var.kms_api_key_alias
        apiKeyTableName    = var.api_key_table_name
      }
    },
      "update_api_key" = {
      allow_agent_execution    = false
      allow_userpool_execution = false

      permissions = {
        link_users    = false
        api_key_table = "write"
        kms_api_key   = "encrypt"
      },
      env = {
        kmsApiKeyAliasName = var.kms_api_key_alias
        apiKeyTableName    = var.api_key_table_name
      }
    },
     "delete_api_key" = {
      allow_agent_execution    = false
      allow_userpool_execution = false

      permissions = {
        link_users    = false
        api_key_table = "delete"
        kms_api_key   = "none"
      },
      env = {
        apiKeyTableName    = var.api_key_table_name
      }
    }
  }
}
