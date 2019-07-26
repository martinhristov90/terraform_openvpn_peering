resource "aws_security_group" "ssh_http_allowed" {
  # This security group is attached to the VPC and it is valid for all EC2 instances running inside it.
  # Deny is default policy.
  name        = "ssh_http_allowed"
  description = "Allow SSH traffic and HTTP from OpenVPN VPC, no other traffic is allowed"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    # Only clients of the OpenVPN can access this instance.
    cidr_blocks = ["192.168.2.0/24"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    # Only clients of the OpenVPN can access this instance.
    cidr_blocks = ["192.168.2.0/24"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    # Only clients of the OpenVPN can access this instance.
    cidr_blocks = ["192.168.2.0/24"]
  }
}

