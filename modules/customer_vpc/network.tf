resource "aws_security_group" "ssh_http_allowed" {
  # This security group is attached to the VPC and it is valid for all EC2 instances running inside it.
  # Deny is default policy.
  name        = "ssh_http_allowed"
  description = "Allow SSH traffic and HTTP from OpenVPN VPC, no other traffic is allowed"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    iterator = port # If ommited the name of the dynamic block should be used.
    for_each = var.ingress_ports
    content {
      from_port = port.value
      to_port   = port.value
      protocol  = "tcp"
      # Only clients of the OpenVPN can access this instance. Subnet of OpenVPN VPC (192.168.2.0/24)
      cidr_blocks = ["192.168.2.0/24"]
    }
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    # Only clients of the OpenVPN can access this instance. Subnet of OpenVPN VPC (192.168.2.0/24)
    cidr_blocks = ["192.168.2.0/24"]
  }
}

