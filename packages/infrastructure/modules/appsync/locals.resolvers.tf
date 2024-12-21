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
  }
}