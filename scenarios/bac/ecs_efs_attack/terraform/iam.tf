
###########  EC2 Roles ###############

resource "aws_iam_role" "k4-ec2-ruse-role" {
  name = "k4-ec2-role-${var.cgid}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
      Name = "k4-ec2-role-${var.cgid}"
      Stack = "${var.stack-name}"
      Scenario = "${var.scenario-name}"
  }
}


#IAM Admin Role

resource "aws_iam_role" "k4-efs-admin-role" {
  name = "k4-efs-admin-role-${var.cgid}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
      Name = "k4-ec2-efsUser-role-${var.cgid}"
      Stack = "${var.stack-name}"
      Scenario = "${var.scenario-name}"
  }
}

###### IAM Lambda Role ######

resource "aws_iam_role" "k4-lambda-role" {
  name = "k4-lambda-role-${var.cgid}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

#Iam Role Policy for ec2 "ruse-box"
resource "aws_iam_policy" "k4-ec2-ruse-role-policy" {
  name = "k4-ec2-ruse-role-policy-${var.cgid}"
  description = "k4-ec2-ruse-role-policy-${var.cgid}"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
              "ecs:Describe*",
              "ecs:List*",
              "ecs:RegisterTaskDefinition",
              "ecs:UpdateService",
              "iam:PassRole",
              "iam:List*",
              "iam:Get*",
              "ec2:CreateTags",
              "ec2:DescribeInstances", 
              "ec2:DescribeImages",
              "ec2:DescribeTags", 
              "ec2:DescribeSnapshots"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_iam_policy" "k4-efs-admin-role-policy" {
  name = "k4-efs-admin-role-policy-${var.cgid}"
  description = "k4-efs-admin-role-policy-${var.cgid}"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
              "elasticfilesystem:ClientMount"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}


################### ECS #####################



#IAM Role
resource "aws_iam_role" "k4-ecs-role" {
  name = "k4-ecs-role-${var.cgid}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
      Name = "k4-ecs-role-${var.cgid}"
      Stack = "${var.stack-name}"
      Scenario = "${var.scenario-name}"
  }
}
#Iam Role Policy
resource "aws_iam_policy" "k4-ecs-role-policy" {
  name = "k4-ecs-role-policy-${var.cgid}"
  description = "k4-ecs-role-policy-${var.cgid}"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeImages",
                "logs:CreateLogStream",
                "ec2:DescribeInstances",
                "ec2:DescribeTags",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:GetAuthorizationToken",
                "ssm:TerminateSession",
                "ec2:DescribeSnapshots",
                "logs:PutLogEvents",
                "ecr:BatchCheckLayerAvailability"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "ssm:StartSession",
            "Resource": "arn:aws:ec2:*:*:instance/*",
            "Condition": {
                "StringEquals": {
                    "aws:ResourceTag/StartSession": "true"
                }
            }
        }
    ]
}
POLICY
}


            