#IAM Role
resource "aws_iam_role" "k4-ec2-role" {
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
#Iam Role Policy
resource "aws_iam_policy" "k4-ec2-role-policy" {
  name = "k4-ec2-role-policy-${var.cgid}"
  description = "k4-ec2-role-policy-${var.cgid}"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "lambda:ListFunctions",
                "lambda:GetFunction",
                "rds:DescribeDBInstances"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}
#IAM Role Policy Attachment
resource "aws_iam_policy_attachment" "k4-ec2-role-policy-attachment" {
  name = "k4-ec2-role-policy-attachment-${var.cgid}"
  roles = [
      "${aws_iam_role.k4-ec2-role.name}"
  ]
  policy_arn = "${aws_iam_policy.k4-ec2-role-policy.arn}"
}
#IAM Instance Profile
resource "aws_iam_instance_profile" "k4-ec2-instance-profile" {
  name = "k4-ec2-instance-profile-${var.cgid}"
  role = "${aws_iam_role.k4-ec2-role.name}"
}
#Security Groups
resource "aws_security_group" "k4-ec2-ssh-security-group" {
  name = "k4-ec2-ssh-${var.cgid}"
  description = "CloudGoat ${var.cgid} Security Group for EC2 Instance over SSH"
  vpc_id = "${aws_vpc.k4-vpc.id}"
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = var.k4_whitelist
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = [
          "0.0.0.0/0"
      ]
  }
  tags = {
    Name = "k4-ec2-ssh-${var.cgid}"
    Stack = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}
#AWS Key Pair
resource "aws_key_pair" "k4-ec2-key-pair" {
  key_name = "k4-ec2-key-pair-${var.cgid}"
  public_key = "${file(var.ssh-public-key-for-ec2)}"
}
#EC2 Instance
resource "aws_instance" "k4-ubuntu-ec2" {
    ami = "ami-0a313d6098716f372"
    instance_type = "t2.micro"
    iam_instance_profile = "${aws_iam_instance_profile.k4-ec2-instance-profile.name}"
    subnet_id = "${aws_subnet.k4-public-subnet-1.id}"
    associate_public_ip_address = true
    vpc_security_group_ids = [
        "${aws_security_group.k4-ec2-ssh-security-group.id}"
    ]
    key_name = "${aws_key_pair.k4-ec2-key-pair.key_name}"
    root_block_device {
        volume_type = "gp2"
        volume_size = 8
        delete_on_termination = true
    }
    user_data = <<-EOF
        #!/bin/bash
        apt-get update
        apt-get install -y postgresql-client
        psql postgresql://${var.rds-username}:${var.rds-password}@${aws_db_instance.k4-psql-rds.endpoint}/${var.rds-database-name} \
        -c "CREATE TABLE sensitive_information (name VARCHAR(100) NOT NULL, value VARCHAR(100) NOT NULL);"
        psql postgresql://${var.rds-username}:${var.rds-password}@${aws_db_instance.k4-psql-rds.endpoint}/${var.rds-database-name} \
        -c "INSERT INTO sensitive_information (name,value) VALUES ('Key1','V\!C70RY-PvyOSDptpOVNX2JDS9K9jVetC1xI4gMO4');"
        psql postgresql://${var.rds-username}:${var.rds-password}@${aws_db_instance.k4-psql-rds.endpoint}/${var.rds-database-name} \
        -c "INSERT INTO sensitive_information (name,value) VALUES ('Key2','V\!C70RY-JpZFReKtvUiWuhyPGF20m4SDYJtOTxws6');"
        EOF
    volume_tags = {
        Name = "CloudGoat ${var.cgid} EC2 Instance Root Device"
        Stack = "${var.stack-name}"
        Scenario = "${var.scenario-name}"
    }
    tags = {
        Name = "k4-ubuntu-ec2-${var.cgid}"
        Stack = "${var.stack-name}"
        Scenario = "${var.scenario-name}"
    }
}