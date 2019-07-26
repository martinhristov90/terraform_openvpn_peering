# This is the VPC in which all resources are going to be crated.
resource "aws_vpc" "openvpn-vpc" {
  # cidr_block for whole VPC, all subnets inside the VPC should be in this address space.
  cidr_block = "192.168.0.0/16"
  # Those two lines enable DNS support, every instance lunched in this VPC is going to get DNS record to its public IP.
  enable_dns_support   = true
  enable_dns_hostnames = true
  # Classic link improves isolation of the VPC.
  enable_classiclink = false
  # The VPC can run on shared hardware.
  instance_tenancy = "default"

  tags = {
    Name = "openvpn-vpc"
  }
}

# Main subnet to be used in the openvpn VPC. It is going to inherit its route tables from the main route table of the openvpn VPC
resource "aws_subnet" "openvpn-subnet" {
  # ID of the VPC to associate the subnet with.
  vpc_id = aws_vpc.openvpn-vpc.id
  # This cidr should be part of the network space of the VPC defined above.
  cidr_block = "192.168.2.0/24"
  # Give public addresses to all instances lunched in this subnet
  map_public_ip_on_launch = "true"
  # Self-explanatory
  availability_zone = "us-east-1a"

  tags = {
    Name = "openvpn-vpc-subnet-1"
  }
}

resource "aws_route_table" "openvpn-vpc-route-table" {
  # ID of the VPC to be created in.
  vpc_id = aws_vpc.openvpn-vpc.id

  route {
    # All traffic that is not part of the local network to be routed to openvpn-vpc-gw
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.openvpn-igw.id
  }

  tags = {
    Name = "testing-vpc-default-route-table"
  }

  # !!! Really important, Terraform should not try to restore the route table as it was, when it was created, more routes are going to be added by vpc_peering.
  lifecycle {
    ignore_changes = all
  }
}

resource "aws_route_table_association" "testing-vpc-route-table-association" {
  # Associating the testing-vpc-route-table with main subnet
  # When you take a look at the main subnet, it is going to have two route table entries, one default inherited from VPC and this one.
  subnet_id      = aws_subnet.openvpn-subnet.id
  route_table_id = aws_route_table.openvpn-vpc-route-table.id
}


# Internet gateway to provide connection with the outside world.
resource "aws_internet_gateway" "openvpn-igw" {
  # ID of the VPC to be created in, later it is going to be associated with routing table.
  vpc_id = aws_vpc.openvpn-vpc.id

  tags = {
    Name = "openvpn-igw"
  }
}

