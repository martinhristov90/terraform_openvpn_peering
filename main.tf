# Networks
# OpenVPN VPC network - 192.168.1.0/24
# Customer VPC netwokr - 10.0.1.0/24

# This module creates the OpenVPN VPC
module "openvpn-vpc" {
  source = "./modules/openvpn_vpc"

  aws_region    = var.openvpn_aws_region
  ami           = var.openvpn_ami
  ec2_user      = var.openvpn_ec2_user
  private_key   = var.openvpn_private_key
  public_key    = var.openvpn_public_key
  ingress_ports = var.openvpn_ingress_ports
  admin_pass    = var.openvpn_admin_pass
  marti_pass    = var.openvpn_marti_pass
}

# This module is going to run instances that are only accesible though the OpenVPN VPC.
module "customer_vpc" {
  source = "./modules/customer_vpc"

  aws_region  = var.customer_aws_region
  ami         = var.customer_ami
  ec2_user    = var.customer_ec2_user
  private_key = var.customer_private_key
  public_key  = var.customer_public_key

}


module "vpc_peering" {
  source = "./modules/vpc_peering/"

  providers = {
    aws.this = "aws"
    aws.peer = "aws"
  }

  this_vpc_id            = module.openvpn-vpc.open_vpn_vpc_id
  peer_vpc_id            = module.customer_vpc.customer_vpc_id
  openvpn_route_table_id = module.openvpn-vpc.openvpn_route_table_id
  testing_route_table_id = module.customer_vpc.testing_route_table_id
  auto_accept_peering    = true

  tags = {
    Name = "openvpn_testing_peering"
  }
}


resource "null_resource" "vpn_setup" {

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/aws_key_pair openvpnas@${module.openvpn-vpc.public_ip}:/home/openvpnas/client.ovpn ."
  }

  depends_on = ["module.openvpn-vpc"]
}