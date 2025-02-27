#AWS SSM Parameters
resource "aws_ssm_parameter" "k4-ec2-public-key" {
  name = "k4-ec2-public-key-${var.cgid}"
  description = "k4-ec2-public-key-${var.cgid}"
  type = "String"
  value = "${file("../cloudgoat.pub")}"
  tags = {
    Name = "k4-ec2-public-key-${var.cgid}"
    Stack = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}
resource "aws_ssm_parameter" "k4-ec2-private-key" {
  name = "k4-ec2-private-key-${var.cgid}"
  description = "k4-ec2-private-key-${var.cgid}"
  type = "String"
  value = "${file("../cloudgoat")}"
  tags = {
    Name = "k4-ec2-private-key-${var.cgid}"
    Stack = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}