#IAM Users
resource "aws_iam_user" "k4-alec" {
  name = "alec"
  tags = {
    Name = "k4-alec-${var.cgid}"
    Stack = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}
resource "aws_iam_access_key" "k4-alec" {
  user = "${aws_iam_user.k4-alec.name}"
}
#IAM User Policies
resource "aws_iam_policy" "k4-alec-policy" {
  name = "k4-alec-policy"
  description = "k4-alec-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "iam:ListRoles",
                "iam:PassRole",
                "iam:ListInstanceProfiles",
                "iam:AddRoleToInstanceProfile",
                "iam:RemoveRoleFromInstanceProfile",
                "ec2:AssociateIamInstanceProfile",
                "ec2:DescribeIamInstanceProfileAssociations",
                "ec2:RunInstances"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "ec2:CreateKeyPair",
            "Resource": "*"
        },
        {
          "Action": [
            "ec2:DescribeInstances","ec2:DescribeVpcs", "ec2:DescribeSubnets",
            "ec2:DescribeSecurityGroups"
          ],
          "Effect": "Allow",
          "Resource": "*"
        }
    ]
}
EOF
}
resource "aws_iam_user_policy_attachment" "k4-alec-attachment" {
  user = "${aws_iam_user.k4-alec.name}"
  policy_arn = "${aws_iam_policy.k4-alec-policy.arn}"
}
# IAM Role for EC2 Mighty
resource "aws_iam_role" "k4-ec2-mighty-role" {
  name = "ec2-mighty-role-${var.cgid}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
  tags = {
      Name = "${var.cgid} EC2 Mighty Role"
      Stack = "${var.stack-name}"
      Scenario = "${var.scenario-name}"
  }
}
# IAM Role for EC2 Meek
resource "aws_iam_role" "k4-ec2-meek-role" {
  name = "ec2-meek-role-${var.cgid}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
  tags = {
      Name = "${var.cgid} EC2 Meek Role"
      Stack = "${var.stack-name}"
      Scenario = "${var.scenario-name}"
  }
}
#IAM Policy for EC2 Mighty
resource "aws_iam_policy" "k4-ec2-mighty-policy" {
  name = "ec2-mighty-policy"
  description = "ec2-mighty-policy"
  policy =  <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
#IAM Policy for EC2 meek
resource "aws_iam_policy" "k4-ec2-meek-policy" {
  name = "ec2-meek-policy"
  description = "ec2-meek-policy"
  policy =  <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "*"
      ],
      "Effect": "Deny",
      "Resource": "*"
    }
  ]
}
EOF
}
#IAM Role Policy Attachment for EC2 Mighty
resource "aws_iam_role_policy_attachment" "k4-ec2-mighty-role-policy-attachment-ec2" {
  role = "${aws_iam_role.k4-ec2-mighty-role.name}"
  policy_arn = "${aws_iam_policy.k4-ec2-mighty-policy.arn}"
}
#IAM Role Policy Attachment for EC2 Meek
resource "aws_iam_role_policy_attachment" "k4-ec2-meek-role-policy-attachment-ec2" {
  role = "${aws_iam_role.k4-ec2-meek-role.name}"
  policy_arn = "${aws_iam_policy.k4-ec2-meek-policy.arn}"
}
#IAM Instance Profile for Meek EC2 instances
resource "aws_iam_instance_profile" "k4-ec2-meek-instance-profile" {
  name = "ec2-instance-profile-${var.cgid}"
  role="${aws_iam_role.k4-ec2-meek-role.name}"
}