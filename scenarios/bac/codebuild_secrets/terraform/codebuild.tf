#IAM Role for AWS CodeBuild Project
resource "aws_iam_role" "k4-codebuild-role" {
  name = "code-build-k4-${var.cgid}-service-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  tags = {
    Name = "code-build-k4-${var.cgid}-service-role"
    Stack = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}
#Inline Policy for AWS CodeBuild Project IAM Role
resource "aws_iam_role_policy" "k4-codebuild-role-policy" {
  name = "code-build-k4-${var.cgid}-policy"
  role = "${aws_iam_role.k4-codebuild-role.name}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeDhcpOptions",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcs"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}
#AWS CodeBuildProjects
resource "aws_codebuild_project" "k4-codebuild-project" {
  name = "k4-codebuild-${var.cgid}"
  build_timeout = 20
  service_role = "${aws_iam_role.k4-codebuild-role.arn}"
  environment {
      compute_type = "BUILD_GENERAL1_SMALL"
      image = "aws/codebuild/standard:1.0"
      type = "LINUX_CONTAINER"
      image_pull_credentials_type = "CODEBUILD"
      privileged_mode = false
      environment_variable {
          name = "calrissian-aws-access-key"
          value = "${aws_iam_access_key.k4-calrissian.id}"
      }
      environment_variable {
          name = "calrissian-aws-secret-key"
          value = "${aws_iam_access_key.k4-calrissian.secret}"
      }
  }
  source {
      type = "NO_SOURCE"
      buildspec = "${file("../assets/buildspec.yml")}"
  }
  artifacts {
      type = "NO_ARTIFACTS"
  }
  tags = {
    Name = "k4-codebuild-${var.cgid}"
    Stack = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}