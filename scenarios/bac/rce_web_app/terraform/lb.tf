#Security Groups
resource "aws_security_group" "k4-lb-http-security-group" {
  name = "k4-lb-http-${local.cgid_suffix}"
  description = "CloudGoat ${var.cgid} Security Group for Application Load Balancer over HTTP"
  vpc_id = "${aws_vpc.k4-vpc.id}"
  ingress {
      from_port = 80
      to_port = 80
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
    Name = "k4-lb-http-${local.cgid_suffix}"
    Stack = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}
#Application Load Balancer
resource "aws_lb" "k4-lb" {
  name = "k4-lb-${local.cgid_suffix}"
  internal = false
  load_balancer_type = "application"
  ip_address_type = "ipv4"
  access_logs {
      bucket = "${aws_s3_bucket.k4-logs-s3-bucket.bucket}"
      prefix = "k4-lb-logs"
      enabled = true
  }
  security_groups = [
      "${aws_security_group.k4-lb-http-security-group.id}"
  ]
  subnets = [
      "${aws_subnet.k4-public-subnet-1.id}",
      "${aws_subnet.k4-public-subnet-2.id}"
  ]
  tags = {
      Name = "k4-lb-${var.cgid}"
      Stack = "${var.stack-name}"
      Scenario = "${var.scenario-name}"
  }
}
#Target Group
resource "aws_lb_target_group" "k4-target-group" {
  # Note: the name cannot be more than 32 characters
  name = "k4-tg-${local.cgid_suffix}"
  port = 9000
  protocol = "HTTP"
  vpc_id = "${aws_vpc.k4-vpc.id}"
  target_type = "instance"
  tags = {
    Name = "k4-target-group-${local.cgid_suffix}"
    Stack = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}
#Target Group Attachment
resource "aws_lb_target_group_attachment" "k4-target-group-attachment" {
  target_group_arn = "${aws_lb_target_group.k4-target-group.arn}"
  target_id = "${aws_instance.k4-ubuntu-ec2.id}"
  port = 9000
}
#Load Balancer Listener
resource "aws_lb_listener" "k4-lb-listener" {
  load_balancer_arn = "${aws_lb.k4-lb.arn}"
  port = 80
  default_action {
      type = "forward"
      target_group_arn = "${aws_lb_target_group.k4-target-group.arn}"
  }
}