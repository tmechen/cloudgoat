#IAM User Credentials
output "k4_output_katarina_access_key_id" {
  value = "${aws_iam_access_key.k4-katarina.id}"
}
output "k4_output_katarina_secret_key" {
  value = "${aws_iam_access_key.k4-katarina.secret}"
  sensitive = true
}
#AWS Account ID
output "k4_output_aws_account_id" {
  value = "${data.aws_caller_identity.aws-account-id.account_id}"
}

output "k4_output_policy_arn" {
  value = "${aws_iam_policy.k4-katarina-policy.arn}"
}

output "k4_output_username" {
  value = "${aws_iam_user.k4-katarina.name}"
}
