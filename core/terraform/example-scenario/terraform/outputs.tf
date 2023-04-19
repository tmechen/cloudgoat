#Required: Always output the AWS Account ID
output "k4_output_aws_account_id" {
  value = "${data.aws_caller_identity.aws-account-id.account_id}"
}
#Example: IAM User Credentials
output "k4_output_johnsmith_access_key_id" {
  value = "${aws_iam_access_key.k4-johnsmith.id}"
}
output "k4_output_johnsmith_secret_key" {
  value = "${aws_iam_access_key.k4-johnsmith.secret}"
}
#Example: output for an SSH key
output "k4_output_ssh_keyname" {
  value = "An SSH key-pair named ${var.ssh-key-name} has been generated stored in this directory."
}
#Example: Always output any important URLs, IPs, or other such infromation
output "k4_output_load_balancer_url" {
  value = "${aws_lb.k4-lb.dns_name}"
}
