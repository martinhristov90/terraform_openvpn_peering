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

# Main subnet to be used in the main VPC. The peering route is going to be added to this route table.
resource "aws_subnet" "main" {
  # ID of the VPC to associate the subnet with.
  vpc_id = aws_vpc.main.id
  # This cidr should be part of the network space of the VPC defined above.
  cidr_block = "10.0.1.0/24"
  # Self-explanatory
  availability_zone = "us-east-1a"

  tags = {
    Name = "testing-vpc-subnet-1"
  }
}

resource "aws_route_table" "testing-vpc-route-table" {
  # ID of the VPC to be created in.
  vpc_id = aws_vpc.main.id

  # Routes to OpenVPN VPC are going to be added to this table. The ID of this table is passed to vpc_peering module.

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
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.testing-vpc-route-table.id
}
