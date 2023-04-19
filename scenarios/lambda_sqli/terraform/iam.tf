#IAM User
resource "aws_iam_user" "emily" {
  name = "Emily"
  tags = {
    Name     = "Emily"
    Stack    = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}

resource "aws_iam_access_key" "emily" {
  user = aws_iam_user.emily.name
}

resource "aws_iam_user_policy" "standard_user" {
  name = "${aws_iam_user.emily.name}-standard-user-assumer"
  user = aws_iam_user.emily.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "arn:aws:iam::940877411605:role/lambda-invoker*"
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
              "iam:Get*",
              "iam:List*",
              "iam:SimulateCustomPolicy",
              "iam:SimulatePrincipalPolicy"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role" "k4-lambda-invoker" {
  name = "${var.cgid}-lambda-invoker"

  inline_policy {
    name = "lambda-invoker"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = [
            "lambda:ListFunctionEventInvokeConfigs",
            "lambda:InvokeFunction",
            "lambda:ListTags",
            "lambda:GetFunction",
            "lambda:GetPolicy"
            ]
          Effect   = "Allow"
          Resource = [
            aws_lambda_function.policy_applier_lambda.arn,
            aws_lambda_function.policy_applier_lambda.arn
          ]
        },
        {
          Action   = [
            "lambda:ListFunctions",
            "iam:Get*",
            "iam:List*",
            "iam:SimulateCustomPolicy",
            "iam:SimulatePrincipalPolicy"
            ]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
    })
  }

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          "AWS": [
            aws_iam_user.emily.arn
          ]
        }
      },
    ]
  })
}

