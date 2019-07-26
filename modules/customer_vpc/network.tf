# Internet gateway to provide connection with the outside world.
resource "aws_internet_gateway" "testing-vpc-gw" {
  # ID of the VPC to be created in, later it is going to be associated with routing table.
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "testing-igw"
  }
}

resource "aws_route_table" "testing-vpc-route-table" {
  # ID of the VPC to be created in.
  vpc_id = aws_vpc.main.id

  route {
    # All traffic that is not part of the local network to be routed to testing-vpc-gw
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.testing-vpc-gw.id
  }

  tags = {
    Name = "testing-vpc-default-route-table"
  }
}


resource "aws_route_table_association" "testing-vpc-route-table-association" {
  # Associating the testing-vpc-route-table with main subnet
  # When you take a look at the main subnet, it is going to have two route table entries, one default inherited from VPC and this one.
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.testing-vpc-route-table.id
}

resource "aws_security_group" "ssh_http_allowed" {
  # This security group is attached to the VPC and it is valid for all EC2 instances running inside it.
  # Deny is default policy.
  name        = "ssh_allowed"
  description = "Allow SSH traffic and HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

