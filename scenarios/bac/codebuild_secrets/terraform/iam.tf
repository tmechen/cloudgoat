resource "aws_iam_user" "k4-calrissian" {
  name = "calrissian"
  tags = {
    Name = "k4-calrissian-${var.cgid}"
    Stack = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}
resource "aws_iam_access_key" "k4-calrissian" {
  user = "${aws_iam_user.k4-calrissian.name}"
}
resource "aws_iam_user" "k4-solo" {
  name = "solo"
  tags = {
    Name = "k4-solo-${var.cgid}"
    Stack = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}
resource "aws_iam_access_key" "k4-solo" {
  user = "${aws_iam_user.k4-solo.name}"
}
#IAM User Policies
resource "aws_iam_policy" "k4-calrissian-policy" {
  name = "k4-calrissian-policy-${var.cgid}"
  description = "k4-calrissian-policy-${var.cgid}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "calrissian",
            "Effect": "Allow",
            "Action": [
                "rds:CreateDBSnapshot",
                "rds:DescribeDBInstances",
                "rds:ModifyDBInstance",
                "rds:RestoreDBInstanceFromDBSnapshot",
                "rds:DescribeDBSubnetGroups",
                "rds:CreateDBSecurityGroup",
                "rds:DeleteDBSecurityGroup",
                "rds:DescribeDBSecurityGroups",
                "rds:AuthorizeDBSecurityGroupIngress",
                "ec2:CreateSecurityGroup",
                "ec2:DeleteSecurityGroup",
                "ec2:DescribeSecurityGroups",
                "ec2:AuthorizeSecurityGroupIngress"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
resource "aws_iam_policy" "k4-solo-policy" {
  name = "k4-solo-policy-${var.cgid}"
  description = "k4-solo-policy-${var.cgid}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "solo",
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets",
                "ssm:DescribeParameters",
                "ssm:GetParameter",
                "codebuild:ListProjects",
                "codebuild:BatchGetProjects",
                "codebuild:ListBuilds",
                "ec2:DescribeInstances",
                "ec2:DescribeVpcs",
                "ec2:DescribeSubnets",
                "ec2:DescribeSecurityGroups"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
#User Policy Attachments
resource "aws_iam_user_policy_attachment" "k4-calrissian-attachment" {
  user = "${aws_iam_user.k4-calrissian.name}"
  policy_arn = "${aws_iam_policy.k4-calrissian-policy.arn}"
}
resource "aws_iam_user_policy_attachment" "k4-solo-attachment" {
  user = "${aws_iam_user.k4-solo.name}"
  policy_arn = "${aws_iam_policy.k4-solo-policy.arn}"
}