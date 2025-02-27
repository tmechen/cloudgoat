#Security Group
resource "aws_security_group" "k4-rds-security-group" {
  name = "k4-rds-psql-${var.cgid}"
  description = "CloudGoat ${var.cgid} Security Group for PostgreSQL RDS Instance"
  vpc_id = "${aws_vpc.k4-vpc.id}"
  ingress {
      from_port = 5432
      to_port = 5432
      protocol = "tcp"
      cidr_blocks = [
          "10.10.10.0/24",
          "10.10.20.0/24",
          "10.10.30.0/24",
          "10.10.40.0/24"
      ]
  }
  ingress {
      from_port = 5432
      to_port = 5432
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
}
#RDS Subnet Group
resource "aws_db_subnet_group" "k4-rds-subnet-group" {
  name = "cloud-goat-rds-subnet-group-${var.cgid}"
  subnet_ids = [
      "${aws_subnet.k4-private-subnet-1.id}",
      "${aws_subnet.k4-private-subnet-2.id}"
  ]
  description = "CloudGoat ${var.cgid} Subnet Group"
}
resource "aws_db_subnet_group" "k4-rds-testing-subnet-group" {
  name = "cloud-goat-rds-testing-subnet-group-${var.cgid}"
  subnet_ids = [
      "${aws_subnet.k4-public-subnet-1.id}",
      "${aws_subnet.k4-public-subnet-2.id}"
  ]
  description = "CloudGoat ${var.cgid} Subnet Group ONLY for Testing with Public Subnets"
}
#RDS PostgreSQL Instance
resource "aws_db_instance" "k4-psql-rds" {
  identifier = "k4-rds-instance-${local.cgid_suffix}"
  engine = "postgres"
  engine_version = "13.7"
  port = "5432"
  instance_class = "db.m5.large"
  db_subnet_group_name = "${aws_db_subnet_group.k4-rds-subnet-group.id}"
  multi_az = false
  username = "${var.rds-username}"
  password = "${var.rds-password}"
  publicly_accessible = false
  vpc_security_group_ids = [
    "${aws_security_group.k4-rds-security-group.id}"
  ]
  storage_type = "gp2"
  allocated_storage = 20
  name = "${var.rds-database-name}"
  apply_immediately = true
  skip_final_snapshot = true

  tags = {
      Name = "k4-rds-instance-${var.cgid}"
      Stack = "${var.stack-name}"
      Scenario = "${var.scenario-name}"
  }
}
