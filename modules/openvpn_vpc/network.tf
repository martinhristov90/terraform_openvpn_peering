# Internet gateway to provide connection with the outside world.
resource "aws_internet_gateway" "openvpn-igw" {
  # ID of the VPC to be created in, later it is going to be associated with routing table.
  vpc_id = aws_vpc.openvpn-vpc.id

  tags = {
    Name = "openvpn-igw"
  }
}

resource "aws_route_table" "openvpn-route-table" {
  # ID of the VPC to be created in.
  vpc_id = aws_vpc.openvpn-vpc.id
  route {
    # All traffic that is not part of the local network to be routed to openvpn-igw
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.openvpn-igw.id
  }
  tags = {
    Name = "testing-vpc-default-route-table"
  }
}

resource "aws_route_table_association" "openvpn-route-table-association" {
  # Associating the openvpn-route-table with main subnet
  # When you take a look at the main subnet, it is going to have two route table entries, one default inherited from VPC and this one.
  subnet_id      = aws_subnet.openvpn-subnet.id
  route_table_id = aws_route_table.openvpn-route-table.id
}

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

  instance                  = aws_instance.openvpn-ec2.id
  depends_on                = ["aws_internet_gateway.openvpn-igw"]
}