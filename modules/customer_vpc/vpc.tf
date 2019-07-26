# This is the VPC in which all resources are going to be crated.
resource "aws_vpc" "main" {
  # cidr_block for whole VPC, all subnets inside the VPC should be in this address space.
  cidr_block = "10.0.0.0/16"
  # Those two lines enable DNS support, every instance lunched in this VPC is going to get DNS record to its public IP.
  enable_dns_support   = true
  enable_dns_hostnames = true
  # Classic link improves isolation of the VPC.
  enable_classiclink = false
  # The VPC can run on shared hardware.
  instance_tenancy = "default"

  tags = {
    Name = "testing-vpc"
  }
}

# Main subnet to be used in the main VPC.
resource "aws_subnet" "main" {
  # ID of the VPC to associate the subnet with.
  vpc_id = aws_vpc.main.id
  # This cidr should be part of the network space of the VPC defined above.
  cidr_block = "10.0.1.0/24"
  # Give public addresses to all instances lunched in this subnet
  map_public_ip_on_launch = "true"
  # Self-explanatory
  availability_zone = "us-east-1a"

  tags = {
    Name = "testing-vpc-subnet-1"
  }
}

