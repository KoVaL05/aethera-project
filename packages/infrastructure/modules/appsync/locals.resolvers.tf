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
      path        = "../resolvers/default"
      kind        = "UNIT"
      type        = "Mutation"
      data_source = "create_api_key_lambda"
    }
  }
}