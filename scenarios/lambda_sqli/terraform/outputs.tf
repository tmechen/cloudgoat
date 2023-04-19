#IAM User Credentials
output "k4_output_emily_access_key_id" {
  value = aws_iam_access_key.emily.id
}
output "k4_output_emily_secret_key" {
  value = aws_iam_access_key.emily.secret
  sensitive = true
}
#AWS Account ID
output "k4_output_aws_account_id" {
  value = data.aws_caller_identity.aws-account-id.account_id
}
output "scenario_k4_id" {
  value = var.cgid
}
output "profile" {
  value = var.profile
}