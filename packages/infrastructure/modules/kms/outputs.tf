output "kms_api_key_arn" {
  value = aws_kms_key.api_key.arn
}

output "kms_api_key_alias_name" {
  value = aws_kms_alias.api_key_alias.name
}
