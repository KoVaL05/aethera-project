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
      path        = "../resolvers/default"
      kind        = "UNIT"
      type        = "Mutation"
      data_source = "default_data_source"
    },
    "notifyCreateApiKey" = {
      path        = "../resolvers/default"
      kind        = "UNIT"
      type        = "Mutation"
      data_source = "default_data_source"
    },
    "notifyUpdateApiKey" = {
      path        = "../resolvers/default"
      kind        = "UNIT"
      type        = "Mutation"
      data_source = "default_data_source"
    },
  }
  private_resolvers = {
    # "getApiKey" = {
    #   path        = "../resolvers/getApiKey/private"
    #   kind        = "UNIT"
    #   type        = "Query"
    #   data_source = "api_key_table_private"
    # }
    # "getAllApiKeys" = {
    #   path        = "../resolvers/getAllApiKeys/private"
    #   kind        = "UNIT"
    #   type        = "Query"
    #   data_source = "api_key_table_private"
    # }
    "createApiKey" = {
      path        = "../resolvers/createApiKey/private"
      kind        = "UNIT"
      type        = "Mutation"
      data_source = "create_api_key_private_lambda"
    },
    "updateApiKey" = {
      path        = "../resolvers/updateApiKey/private"
      kind        = "UNIT"
      type        = "Mutation"
      data_source = "update_api_key_private_lambda"
    },
    # "deleteApiKey" = {
    #   path        = "../resolvers/deleteApiKey/private"
    #   kind        = "UNIT"
    #   type        = "Mutation"
    #   data_source = "api_key_table_private"
    # }
  }
}