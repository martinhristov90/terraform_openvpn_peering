# Networks
# OpenVPN VPC network - 192.168.1.0/24
# Customer VPC netwokr - 10.0.1.0/24

module "openvpn-vpc" {
  source = "./modules/openvpn_vpc"

  aws_region    = var.aws_region
  ami           = var.ami
  ec2_user      = var.ec2_user
  private_key   = var.private_key
  public_key    = var.public_key
  ingress_ports = var.ingress_ports
  admin_pass    = var.admin_pass
  marti_pass    = var.marti_pass

}




module "customer_vpc" {
  source = "./modules/customer_vpc"
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
    Name        = "tf-single-account-single-region-${module.openvpn-vpc.public_ip}"
    Environment = "Test"
  }
}


