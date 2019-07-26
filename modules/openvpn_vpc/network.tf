
resource "aws_security_group" "ssh_http_allowed" {
  # This security group is attached to the VPC and it is valid for all EC2 instances running inside it.
  # Deny is default policy.
  name        = "ssh_allowed"
  description = "Allow SSH traffic and HTTP admin traffic and OVPN"
  vpc_id      = aws_vpc.openvpn-vpc.id

  dynamic "ingress" {
    iterator = port
    for_each = var.ingress_ports
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "open-vpn-eip" {
  vpc = true

  instance   = aws_instance.openvpn-ec2.id
  depends_on = ["aws_internet_gateway.openvpn-igw"]
}