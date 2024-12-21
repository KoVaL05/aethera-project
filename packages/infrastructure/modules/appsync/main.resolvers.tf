resource "aws_appsync_resolver" "unit_kind_resolvers" {
  for_each = {
    for key, value in local.resolvers : key => value
    if value.kind == "UNIT"
  }

  api_id = aws_appsync_graphql_api.api_key_public.id

  kind        = "UNIT"
  type        = each.value.type
  data_source = each.value.data_source
  field       = each.key
  code        = file(format("%s/%s/index.mjs", path.root, each.value.path))


  runtime {
    name            = "APPSYNC_JS"
    runtime_version = "1.0.0"
  }
}
