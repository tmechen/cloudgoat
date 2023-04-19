#Security Groups
resource "aws_security_group" "k4-ec2-ssh-security-group" {
  name = "ec2-ssh-${var.cgid}"
  description = "${var.cgid} Security Group for EC2 Instance over SSH"
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
    Name = "ec2-ssh-${var.cgid}"
    Stack = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}
resource "aws_security_group" "k4-ec2-http-https-security-group" {
  name = "ec2-http-${var.cgid}"
  vpc_id = "${aws_vpc.k4-vpc.id}"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = var.k4_whitelist
  }
  ingress {
      from_port = 443
      to_port = 443
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
    Name = "ec2-http-${var.cgid}"
    Stack = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}

data "aws_ami" "ubuntu_2204" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server*"]
  }
}

#EC2 Instance
resource "aws_instance" "k4-super-critical-security-server" {
  ami = data.aws_ami.ubuntu_2204.id
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.k4-public-subnet.id}"
  associate_public_ip_address = true
  vpc_security_group_ids = [
      "${aws_security_group.k4-ec2-ssh-security-group.id}",
      "${aws_security_group.k4-ec2-http-https-security-group.id}"
  ]
  root_block_device {
      volume_type = "gp3"
      volume_size = 8
      delete_on_termination = true
  }
  volume_tags = {
      Name = "${var.cgid} Instance Root Device"
      Stack = "${var.stack-name}"
      Scenario = "${var.scenario-name}"
  }
  tags = {
      Name = "${var.cgid} SuperWichtigerSichererServer"
      Stack = "${var.stack-name}"
      Scenario = "${var.scenario-name}"
  }
}