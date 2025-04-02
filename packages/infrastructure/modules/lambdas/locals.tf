locals {
  lambda_functions_data = {
    "subject_group_executor" = {
      allow_agent_execution    = true
      allow_userpool_execution = false
      permissions = {
        vpc_endpoint         = "none"
        link_users           = false
        api_key_table        = "none"
        kms_api_key          = "none"
        api_key_stream       = false
        call_api_key_appsync = false
      },
      env = {}
    },
    "pre_signup" = {
      allow_agent_execution    = false
      allow_userpool_execution = true
      permissions = {
        vpc_endpoint         = "none"
        link_users           = true
        api_key_table        = "none"
        kms_api_key          = "none"
        api_key_stream       = false
        call_api_key_appsync = false
      },
      env = {}
    },
    "create_api_key" = {
      allow_agent_execution    = false
      allow_userpool_execution = false

      permissions = {
        vpc_endpoint         = "none"
        link_users           = false
        api_key_table        = "write"
        kms_api_key          = "encrypt"
        api_key_stream       = false
        call_api_key_appsync = false
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
        vpc_endpoint         = "none"
        link_users           = false
        api_key_table        = "write"
        kms_api_key          = "encrypt"
        api_key_stream       = false
        call_api_key_appsync = false
      },
      env = {
        kmsApiKeyAliasName = var.kms_api_key_alias
        apiKeyTableName    = var.api_key_table_name
      }
    },
    "create_api_key_private" = {
      allow_agent_execution    = false
      allow_userpool_execution = false

      permissions = {
        vpc_endpoint         = "none"
        link_users           = false
        api_key_table        = "write"
        kms_api_key          = "encrypt"
        api_key_stream       = false
        call_api_key_appsync = false
      },
      env = {
        kmsApiKeyAliasName = var.kms_api_key_alias
        apiKeyTableName    = var.api_key_table_name
        userPoolId         = var.user_pool_id
      }
    },
    "update_api_key_private" = {
      allow_agent_execution    = false
      allow_userpool_execution = false

      permissions = {
        vpc_endpoint         = "none"
        link_users           = false
        api_key_table        = "write"
        kms_api_key          = "encrypt"
        api_key_stream       = false
        call_api_key_appsync = false
      },
      env = {
        kmsApiKeyAliasName = var.kms_api_key_alias
        apiKeyTableName    = var.api_key_table_name
      }
    },
    "create_vpc_endpoint" = {
      allow_agent_execution    = false
      allow_userpool_execution = false

      permissions = {
        vpc_endpoint         = "create"
        link_users           = false
        api_key_table        = "none"
        kms_api_key          = "none"
        api_key_stream       = false
        call_api_key_appsync = false
      },
      env = {
        VPC_ID = var.private_appsync_vpc_id
      }
    },
    "delete_vpc_endpoint" = {
      allow_agent_execution    = false
      allow_userpool_execution = false

      permissions = {
        vpc_endpoint         = "delete"
        link_users           = false
        api_key_table        = "none"
        kms_api_key          = "none"
        api_key_stream       = false
        call_api_key_appsync = false
      },
      env = {
        VPC_ID            = var.private_appsync_vpc_id
        SECURITY_GROUP_ID = var.private_appsync_sg_id
        SUBNET_IDS        = var.private_appsync_subnet_ids
        currentRegion     = data.aws_region.current.name
      }
    },
  }
}
