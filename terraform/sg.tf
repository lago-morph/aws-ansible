module "ssh_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "host-access"
  description = "Security group for access to hosts"
  vpc_id      = module.vpc.vpc_id

  ingress_rules       = ["ssh-tcp", "http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 8
      to_port     = 0
      protocol    = "icmp"
      description = "ping"
      cidr_blocks = "0.0.0.0/0"
    }
  ]


  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}
