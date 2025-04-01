locals {
  lambda_functions_data = {
    "" = {
      permissions = {
        api_key_stream       = true
        call_api_key_appsync = true
      },
      env = {


      }
    },
  }
}
