#AWS Account ID
output "k4_output_aws_account_id" {
  value = "${data.aws_caller_identity.aws-account-id.account_id}"
}
#IAM User Credentials
output "k4_output_lara_access_key_id" {
  value = "${aws_iam_access_key.k4-lara.id}"
}
output "k4_output_lara_secret_key" {
  value = "${aws_iam_access_key.k4-lara.secret}"
  sensitive = true
}
output "k4_output_mcduck_access_key_id" {
  value = "${aws_iam_access_key.k4-mcduck.id}"
}
output "k4_output_mcduck_secret_key" {
  value = "${aws_iam_access_key.k4-mcduck.secret}"
  sensitive = true
}