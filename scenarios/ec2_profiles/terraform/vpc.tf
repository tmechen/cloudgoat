#VPC
resource "aws_vpc" "k4-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
      Name = "${var.cgid} VPC"
      Stack = "${var.stack-name}"
      Scenario = "${var.scenario-name}"
  }
}
#Internet Gateway
resource "aws_internet_gateway" "k4-internet-gateway" {
  vpc_id = "${aws_vpc.k4-vpc.id}"
  tags = {
      Name = "${var.cgid} Internet Gateway"
      Stack = "${var.stack-name}"
      Scenario = "${var.scenario-name}"
  }
}
#Public Subnet
resource "aws_subnet" "k4-public-subnet" {
  availability_zone = "${var.region}a"
  map_public_ip_on_launch = true
  cidr_block = "10.0.10.0/24"
  vpc_id = "${aws_vpc.k4-vpc.id}"
  tags = {
      Name = "${var.cgid} Public Subnet"
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
      Name = "${var.cgid} Route Table for Public Subnet"
      Stack = "${var.stack-name}"
      Scenario = "${var.scenario-name}"
  }
}
#Public Subnet Routing Association
resource "aws_route_table_association" "k4-public-subnet-route-association" {
  subnet_id = "${aws_subnet.k4-public-subnet.id}"
  route_table_id = "${aws_route_table.k4-public-subnet-route-table.id}"
}