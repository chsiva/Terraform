terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-098f16afa9edf40be" # RHEL Linux-8
  instance_type = "t2.micro"
  #subnet_id              = "subnet-***"
  vpc_security_group_ids = ["sg-***"]
  tags =  {
    Name = "testing_with_terraform"
    env  = "test"
    dept = "cloud"
    costcenter = "1234"
}   
}
resource "null_resource" "stop_instance" {
  provisioner "local-exec" {
    command = "aws ec2 stop-instances --instance-ids ${aws_instance.example.id}"
  }
}
