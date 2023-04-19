#IAM User
resource "aws_iam_user" "k4-marvin" {
  name = "Marvin"
  tags = {
    Name     = "Marvin"
    Stack    = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}

resource "aws_iam_access_key" "k4-marvin" {
  user = aws_iam_user.k4-marvin.name
}

# IAM roles
resource "aws_iam_role" "k4-lambdaManager-role" {
  name = "lambdaManager-role-${var.cgid}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "${aws_iam_user.k4-marvin.arn}"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
    Name = "debug-role-${var.cgid}"
    Stack = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}

resource "aws_iam_role" "k4-debug-role" {
  name = "debug-role-${var.cgid}"
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
  tags = {
    Name = "debug-role-${var.cgid}"
    Stack = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}

# IAM Policies
resource "aws_iam_policy" "k4-lambdaManager-policy" {
  name = "lambdaManager-policy-${var.cgid}"
  description = "lambdaManager-policy-${var.cgid}"
  policy =<<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "lambdaManager",
            "Effect": "Allow",
            "Action": [
                "lambda:*",
                "iam:PassRole"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "k4-marvin-policy" {
  name = "marvin-policy-${var.cgid}"
  description = "marvin-policy-${var.cgid}"
  policy =<<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "MarvinPolicy",
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole",
                "iam:List*",
                "iam:Get*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

#Policy Attachments
resource "aws_iam_role_policy_attachment" "k4-debug-role-attachment" {
  role = aws_iam_role.k4-debug-role.name
  policy_arn = data.aws_iam_policy.administrator-full-access.arn
}

resource "aws_iam_role_policy_attachment" "k4-lambdaManager-role-attachment" {
  role = aws_iam_role.k4-lambdaManager-role.name
  policy_arn = aws_iam_policy.k4-lambdaManager-policy.arn
}

resource "aws_iam_user_policy_attachment" "k4-marvin-attachment" {
  user = aws_iam_user.k4-marvin.name
  policy_arn = aws_iam_policy.k4-marvin-policy.arn
}