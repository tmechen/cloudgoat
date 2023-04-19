#IAM Users
resource "aws_iam_user" "k4-solus" {
  name = "solus-${var.cgid}"
  tags = {
    Name = "k4-solus-${var.cgid}"
    Stack = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}
resource "aws_iam_access_key" "k4-solus" {
  user = "${aws_iam_user.k4-solus.name}"
}
resource "aws_iam_user" "k4-wrex" {
  name = "wrex-${var.cgid}"
  tags = {
    Name = "k4-wrex-${var.cgid}"
    Stack = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}
resource "aws_iam_access_key" "k4-wrex" {
  user = "${aws_iam_user.k4-wrex.name}"
}
resource "aws_iam_user" "k4-shepard" {
  name = "shepard-${var.cgid}"
  tags = {
    Name = "k4-shepard-${var.cgid}"
    Stack = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}
resource "aws_iam_access_key" "k4-shepard" {
  user = "${aws_iam_user.k4-shepard.name}"
}
#IAM User Policies
resource "aws_iam_policy" "k4-solus-policy" {
  name = "k4-solus-policy-${var.cgid}"
  description = "k4-solus-policy-${var.cgid}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "solus",
            "Effect": "Allow",
            "Action": [
                "lambda:Get*",
                "lambda:List*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
resource "aws_iam_policy" "k4-wrex-policy" {
  name = "k4-wrex-policy-${var.cgid}"
  description = "k4-wrex-policy-${var.cgid}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "wrex",
            "Effect": "Allow",
            "Action": [
                "ec2:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
resource "aws_iam_policy" "k4-shepard-policy" {
  name = "k4-shepard-policy-${var.cgid}"
  description = "k4-shepard-policy-${var.cgid}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "shepard",
            "Effect": "Allow",
            "Action": [
                "lambda:Get*",
                "lambda:Invoke*",
                "lambda:List*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
#User Policy Attachments
resource "aws_iam_user_policy_attachment" "k4-solus-attachment" {
  user = "${aws_iam_user.k4-solus.name}"
  policy_arn = "${aws_iam_policy.k4-solus-policy.arn}"
}
resource "aws_iam_user_policy_attachment" "k4-wrex-attachment" {
  user = "${aws_iam_user.k4-wrex.name}"
  policy_arn = "${aws_iam_policy.k4-wrex-policy.arn}"
}
resource "aws_iam_user_policy_attachment" "k4-shepard-attachment" {
  user = "${aws_iam_user.k4-shepard.name}"
  policy_arn = "${aws_iam_policy.k4-shepard-policy.arn}"
}