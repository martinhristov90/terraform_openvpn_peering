# Networks
# OpenVPN VPC network - 192.168.1.0/24
# Customer VPC netwokr - 10.0.1.0/24

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


module "customer_vpc" {
  source = "./modules/customer_vpc"

  aws_region  = var.customer_aws_region
  ami         = var.customer_ami
  ec2_user    = var.customer_ec2_user
  private_key = var.customer_private_key
  public_key  = var.customer_public_key

}


module "vpc_peering" {
  source  = "grem11n/vpc-peering/aws"
  version = "2.1.0"

  providers = {
    aws.this = "aws"
    aws.peer = "aws"
  }

  this_vpc_id = module.openvpn-vpc.open_vpn_vpc_id
  peer_vpc_id = module.customer_vpc.customer_vpc_id

  auto_accept_peering = true

  tags = {
    Name        = "openvpn_testing_peering"
    Environment = "Test"
  }
}


