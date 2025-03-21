data "local_file" "api_key_schema" {
  filename = format("%s/graphql/api_key.gql", path.module)
}

data "local_file" "api_key_private_schema" {
  filename = format("%s/graphql/api_key_private.gql", path.module)
}