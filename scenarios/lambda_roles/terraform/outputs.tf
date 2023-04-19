#IAM User Credentials
output "k4_output_marvin_access_key_id" {
  value = aws_iam_access_key.k4-marvin.id
}
output "k4_output_marvin_secret_key" {
  value = aws_iam_access_key.k4-marvin.secret
  sensitive = true
}
#AWS Account ID
output "k4_output_aws_account_id" {
  value = data.aws_caller_identity.aws-account-id.account_id
}