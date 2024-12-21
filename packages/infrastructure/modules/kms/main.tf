resource "aws_kms_key" "api_key" {
  description         = "KMS API Key key"
  is_enabled          = true
  enable_key_rotation = true

  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMETRIC_DEFAULT"


}

resource "aws_kms_alias" "api_key_alias" {
  name          = "alias/jwt"
  target_key_id = aws_kms_key.api_key.key_id
}