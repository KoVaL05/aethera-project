resource "aws_dynamodb_table" "api_key_table" {
  name         = format("api_key_table_%s", var.random_name)
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "keyType"
    type = "S"
  }

  attribute {
    name = "value"
    type = "B"
  }

  global_secondary_index {
    name               = "KeyTypeIndex"
    hash_key           = "keyType"
    range_key          = "userId"
    projection_type    = "INCLUDE"
    non_key_attributes = ["value", "createdAt"]
  }

  global_secondary_index {
    name               = "UIDIndex"
    hash_key           = "userId"
    range_key          = "keyType"
    projection_type    = "INCLUDE"
    non_key_attributes = ["value", "createdAt"]
  }

  global_secondary_index {
    name               = "APIKeyIndex"
    hash_key           = "value"
    range_key          = "userId"
    projection_type    = "INCLUDE"
    non_key_attributes = ["keyType", "createdAt"]
  }
}
