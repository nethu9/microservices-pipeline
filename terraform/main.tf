provider "aws" {
  region = var.region
}

resource "aws_key_pair" "deployer" {
  key_name   = var.k8s-key
  public_key = file(var.k8s-key-path)
}

resource "aws_security_group" "k8s-sg" {
  name = "K8s-sg"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "master" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.k8s-sg.id]
  key_name               = aws_key_pair.deployer.key_name
  user_data              = file("scripts/master.sh")
  tags = {
    Name = "master"
  }
}

resource "aws_instance" "woker" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.k8s-sg.id]
  count                  = var.workers
  user_data              = file("scripts/master.sh")
  tags = {
    Name = "worker-${count.index + 1}"
  }
}

resource "aws_instance" "git_runner" {
  ami                    = var.runner_instance_type
  instance_type          = var.runner_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.k8s-sg.id]
  tags = {
    Name = "GIT-Runner"
  }
}