#IAM Users
resource "aws_iam_user" "k4-katarina" {
  name = "Katarina"
  tags = {
    Name     = "Katarina"
    Stack    = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}

resource "aws_iam_access_key" "k4-katarina" {
  user = "${aws_iam_user.k4-katarina.name}"
}

#IAM User Policies
resource "aws_iam_policy" "k4-katarina-policy" {
  name        = "katarina-policy-${var.cgid}"
  description = "katarina-policy"
  policy      = "${file("../assets/policies/v1.json")}"
}

#IAM Policy Attachments
resource "aws_iam_user_policy_attachment" "k4-katarina-attachment" {
  user       = "${aws_iam_user.k4-katarina.name}"
  policy_arn = "${aws_iam_policy.k4-katarina-policy.arn}"
}
