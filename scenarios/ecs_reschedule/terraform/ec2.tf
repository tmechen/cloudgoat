data "aws_ami" "aws_optimized_ecs" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami*amazon-ecs-optimized"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["591542846629"] # AWS
}

locals {
  user_data = <<EOH
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.ecs_cluster.name} >> /etc/ecs/ecs.config
EOH
}

resource "aws_instance" "vulnsite" {
  ami                         = data.aws_ami.aws_optimized_ecs.id
  iam_instance_profile        = aws_iam_instance_profile.ecs_agent.name
  vpc_security_group_ids      = [aws_security_group.ecs_sg.id]
  user_data                   = local.user_data
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public.id

  tags = {
    "Name" = "${var.scenario-name}-${var.cgid}-vulnsite"
  }
}

resource "aws_instance" "vault" {
  ami                         = data.aws_ami.aws_optimized_ecs.id
  iam_instance_profile        = aws_iam_instance_profile.ecs_agent.name
  vpc_security_group_ids      = [aws_security_group.ecs_sg.id]
  user_data                   = local.user_data
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public.id

  tags = {
    "Name" = "${var.scenario-name}-${var.cgid}-vault"
  }
}