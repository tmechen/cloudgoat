#IAM Users
resource "aws_iam_user" "k4-lara" {
  name = "lara"
  tags = {
    Name = "k4-lara-${var.cgid}"
    Stack = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}
resource "aws_iam_access_key" "k4-lara" {
  user = "${aws_iam_user.k4-lara.name}"
}
resource "aws_iam_user" "k4-mcduck" {
  name = "McDuck"
  tags = {
    Name = "k4-mcduck-${var.cgid}"
    Stack = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}
resource "aws_iam_access_key" "k4-mcduck" {
  user = "${aws_iam_user.k4-mcduck.name}"
}

#IAM User Policies
resource "aws_iam_policy" "k4-lara-policy" {
  name = "k4-lara-s3-policy"
  description = "k4-lara-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::k4-logs-s3-bucket-${local.cgid_suffix}"
    },
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::k4-logs-s3-bucket-${local.cgid_suffix}/*"
    },
    {
      "Action": [
        "s3:ListAllMyBuckets"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeVpcs",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "rds:DescribeDBInstances",
        "elasticloadbalancing:DescribeLoadBalancers"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
resource "aws_iam_policy" "k4-mcduck-policy" {
  name = "k4-mcduck-s3-policy"
  description = "k4-mcduck-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::k4-keystore-s3-bucket-${local.cgid_suffix}"
    },
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::k4-keystore-s3-bucket-${local.cgid_suffix}/*"
    },
    {
      "Action": [
        "s3:ListAllMyBuckets"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeVpcs",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "rds:DescribeDBInstances"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
#IAM User Policy Attachments
resource "aws_iam_user_policy_attachment" "k4-lara-attachment" {
  user = "${aws_iam_user.k4-lara.name}"
  policy_arn = "${aws_iam_policy.k4-lara-policy.arn}"
}
resource "aws_iam_user_policy_attachment" "k4-mcduck-attachment" {
  user = "${aws_iam_user.k4-mcduck.name}"
  policy_arn = "${aws_iam_policy.k4-mcduck-policy.arn}"
}