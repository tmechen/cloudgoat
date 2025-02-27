resource "aws_vpc" "k4-vpc" {
  cidr_block = "10.10.0.0/16"
  enable_dns_hostnames = true
  tags = {
      Name = "CloudGoat ${var.cgid} VPC"
      Stack = "${var.stack-name}"
      Scenario = "${var.scenario-name}"
  }
}
#Internet Gateway
resource "aws_internet_gateway" "k4-internet-gateway" {
  vpc_id = "${aws_vpc.k4-vpc.id}"
  tags = {
      Name = "CloudGoat ${var.cgid} Internet Gateway"
      Stack = "${var.stack-name}"
      Scenario = "${var.scenario-name}"
  }
}
#Public Subnets
resource "aws_subnet" "k4-public-subnet-1" {
  availability_zone = "${var.region}a"
  cidr_block = "10.10.10.0/24"
  vpc_id = "${aws_vpc.k4-vpc.id}"
  tags = {
      Name = "CloudGoat ${var.cgid} Public Subnet #1"
      Stack = "${var.stack-name}"
      Scenario = "${var.scenario-name}"
  }
}
resource "aws_subnet" "k4-public-subnet-2" {
  availability_zone = "${var.region}b"
  cidr_block = "10.10.20.0/24"
  vpc_id = "${aws_vpc.k4-vpc.id}"
  tags = {
      Name = "CloudGoat ${var.cgid} Public Subnet #2"
      Stack = "${var.stack-name}"
      Scenario = "${var.scenario-name}"
  }
}
#Private Subnets
resource "aws_subnet" "k4-private-subnet-1" {
  availability_zone = "${var.region}a"
  cidr_block = "10.10.30.0/24"
  vpc_id = "${aws_vpc.k4-vpc.id}"
  tags = {
      Name = "CloudGoat ${var.cgid} Private Subnet #1"
      Stack = "${var.stack-name}"
      Scenario = "${var.scenario-name}"
  }
}
resource "aws_subnet" "k4-private-subnet-2" {
  availability_zone = "${var.region}b"
  cidr_block = "10.10.40.0/24"
  vpc_id = "${aws_vpc.k4-vpc.id}"
  tags = {
      Name = "CloudGoat ${var.cgid} Private Subnet #2"
      Stack = "${var.stack-name}"
      Scenario = "${var.scenario-name}"
  }
}
#Public Subnet Routing Table
resource "aws_route_table" "k4-public-subnet-route-table" {
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.k4-internet-gateway.id}"
  }
  vpc_id = "${aws_vpc.k4-vpc.id}"
  tags = {
      Name = "CloudGoat ${var.cgid} Route Table for Public Subnet"
      Stack = "${var.stack-name}"
      Scenario = "${var.scenario-name}"
  }
}
#Private Subnet Routing Table
resource "aws_route_table" "k4-private-subnet-route-table" {
  vpc_id = "${aws_vpc.k4-vpc.id}"
  tags = {
      Name = "CloudGoat ${var.cgid} Route Table for Private Subnet"
      Stack = "${var.stack-name}"
      Scenario = "${var.scenario-name}"
  }
}
#Public Subnets Routing Associations
resource "aws_route_table_association" "k4-public-subnet-1-route-association" {
  subnet_id = "${aws_subnet.k4-public-subnet-1.id}"
  route_table_id = "${aws_route_table.k4-public-subnet-route-table.id}"
}
resource "aws_route_table_association" "k4-public-subnet-2-route-association" {
  subnet_id = "${aws_subnet.k4-public-subnet-2.id}"
  route_table_id = "${aws_route_table.k4-public-subnet-route-table.id}"
}
#Private Subnets Routing Associations
resource "aws_route_table_association" "k4-priate-subnet-1-route-association" {
  subnet_id = "${aws_subnet.k4-private-subnet-1.id}"
  route_table_id = "${aws_route_table.k4-private-subnet-route-table.id}"
}
resource "aws_route_table_association" "k4-priate-subnet-2-route-association" {
  subnet_id = "${aws_subnet.k4-private-subnet-2.id}"
  route_table_id = "${aws_route_table.k4-private-subnet-route-table.id}"
}