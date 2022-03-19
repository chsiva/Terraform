// For this task to be achieved below details are required.

// EC2, Target groups, subnets from 2 availability zones (1 from from each) , Alb, target groups, certificate for Listner 443.


provider "aws" {
  region     = "us-east-1"
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "alb-test-ec2attach"

  load_balancer_type = "application"

  vpc_id             = "<vpc-id>"
  subnets            = ["<sub-id1>","<sub-id2>"]
  security_groups    = ["<sgid"]


  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = [
        {
          target_id = "<instance-id>"
          port = 80
        }
      ]
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]
  
  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = "<certificate-here>"
      target_group_index = 0
    }
  ]
}
