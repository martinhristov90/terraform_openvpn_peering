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

# This is the main route table for the VPC, the peering route is going to be added to this route table.
resource "aws_default_route_table" "default-table-openvpc" {
  default_route_table_id = "${aws_vpc.openvpn-vpc.default_route_table_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.openvpn-igw.id
  }

  tags = {
    Name = "default table openvpn vpc"
  }
}

# Internet gateway to provide connection with the outside world.
resource "aws_internet_gateway" "openvpn-igw" {
  # ID of the VPC to be created in, later it is going to be associated with routing table.
  vpc_id = aws_vpc.openvpn-vpc.id

  tags = {
    Name = "openvpn-igw"
  }
}

