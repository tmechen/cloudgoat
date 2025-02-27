
#Required: Always output the AWS Account ID
output "k4_output_aws_account_id" {
  value = "${data.aws_caller_identity.aws-account-id.account_id}"
}

output "ruse_box_IP"{
  value = "${aws_instance.k4-ruse-ec2.public_ip}"
}

output "ssh_command" {
  value = "ssh -i cloudgoat ubuntu@\\${aws_instance.k4-ruse-ec2.public_ip}"
}
