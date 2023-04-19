#IAM User Credentials
output "k4_output_alec_access_key_id" {
  value = "${aws_iam_access_key.k4-alec.id}"
}
output "k4_output_alec_secret_key" {
  value = "${aws_iam_access_key.k4-alec.secret}"
  sensitive = true
}
#AWS Account ID
output "k4_output_aws_account_id" {
  value = "${data.aws_caller_identity.aws-account-id.account_id}"
}