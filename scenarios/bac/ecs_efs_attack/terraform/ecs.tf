resource "aws_ecs_cluster" "k4-cluster" {
    name = "k4-cluster-${var.cgid}"
}


resource "aws_ecs_task_definition" "k4-webapp" {
  family = "webapp"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  task_role_arn = "${aws_iam_role.k4-ecs-role.arn}"
  execution_role_arn = "${aws_iam_role.k4-ecs-role.arn}"

  container_definitions = <<DEFINITION
[
  {
    "cpu": 128,
    "command": [
            "/bin/sh -c \"echo '<html> <head> <title>CloudGoat EC2 </title> <style>body {margin-top: 40px; background-color: #333;} </style> </head><body> <div style=color:white;text-align:center> <h1>CloudGoat ...</h1> <h2>Welcome!</h2> </div></body></html>' >  /usr/local/apache2/htdocs/index.html && httpd-foreground\""
         ],
         "entryPoint": [
            "sh",
            "-c"
         ],
    "essential": true,
    "image": "httpd:2.4",
    "memory": 128,
    "memoryReservation": 64,
    "name": "webapp",
    "portMappings": [ 
            { 
               "containerPort": 80,
               "hostPort": 80,
               "protocol": "tcp"
            }
         ]
  }
]
DEFINITION
}


data "aws_ecs_task_definition" "k4-webapp" {
  task_definition = "${aws_ecs_task_definition.k4-webapp.family}"
}

resource "aws_ecs_service" "k4-webapp" {
  name          = "k4-webapp-${var.cgid}"
  cluster       = "${aws_ecs_cluster.k4-cluster.name}"
  desired_count = 1
  launch_type   = "FARGATE"

 network_configuration  {
    security_groups = [aws_security_group.k4-ecs-http-security-group.id]
    subnets         = ["${aws_subnet.k4-public-subnet-1.id}"]
    assign_public_ip = true
  }

  # Track the latest ACTIVE revision
  task_definition = "${aws_ecs_task_definition.k4-webapp.family}:${max("${aws_ecs_task_definition.k4-webapp.revision}", "${data.aws_ecs_task_definition.k4-webapp.revision}")}"
}


resource "aws_iam_policy_attachment" "k4-ecs-role-policy-attachment" {
  name = "k4-ecs-role-policy-attachment-${var.cgid}"
  roles = [
      "${aws_iam_role.k4-ecs-role.name}"
  ]
  policy_arn = "${aws_iam_policy.k4-ecs-role-policy.arn}"
}


resource "aws_security_group" "k4-ecs-http-security-group" {
  name = "k4-ecs-http-${var.cgid}"
  description = "CloudGoat ${var.cgid} Security Group for ecs"
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
    Name = "k4-ecs-http-${var.cgid}"
    Stack = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}