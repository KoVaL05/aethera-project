locals {
  resolvers = {
    "getApiKey" = {
      path        = "../resolvers/getApiKey"
      kind        = "UNIT"
      type        = "Query"
      data_source = "api_key_table"
    }
    "getAllApiKeys" = {
      path        = "../resolvers/getAllApiKeys"
      kind        = "UNIT"
      type        = "Query"
      data_source = "api_key_table"
    }
    "createApiKey" = {
      path        = "../resolvers/createApiKey"
      kind        = "UNIT"
      type        = "Mutation"
      data_source = "create_api_key_lambda"
    },
    "updateApiKey" = {
       path        = "../resolvers/updateApiKey"
      kind        = "UNIT"
      type        = "Mutation"
      data_source = "update_api_key_lambda"
    },
    "deleteApiKey" = {
      path        = "../resolvers/deleteApiKey"
      kind        = "UNIT"
      type        = "Mutation"
      data_source = "api_key_table"
    },
     "notifyDeleteApiKey" = {
      path        = "../resolvers/defaultSubscriptions"
      kind        = "UNIT"
      type        = "Subscription"
      data_source = "default_data_source"
    },
  "notifyCreateApiKey" = {
      path        = "../resolvers/defaultSubscriptions"
      kind        = "UNIT"
      type        = "Subscription"
      data_source = "default_data_source"
    },
  "notifyDeleteApiKey" = {
      path        = "../resolvers/defaultSubscriptions"
      kind        = "UNIT"
      type        = "Subscription"
      data_source = "default_data_source"
    },
  }
  
}