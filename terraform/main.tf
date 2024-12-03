data "aws_ami" "ubuntu_focal" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "host" {

  ami                         = data.aws_ami.ubuntu_focal.id
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [module.ssh_sg.security_group_id]
  key_name                    = aws_key_pair.jonathan.key_name
  private_dns_name_options {
    hostname_type = "resource-name"
  }

  metadata_options {
    instance_metadata_tags = "enabled"
  }

  tags = {
    Name = "host"
  }
}
