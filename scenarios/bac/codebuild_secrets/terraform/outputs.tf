
#Required: Always output the AWS Account ID
output "k4_output_aws_account_id" {
  value = "${data.aws_caller_identity.aws-account-id.account_id}"
}
output "k4_output_solo_access_key_id" {
  value = "${aws_iam_access_key.k4-solo.id}"
}
output "k4_output_solo_secret_key" {
  value = "${aws_iam_access_key.k4-solo.secret}"
  sensitive = true
}