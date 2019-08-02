# Networks
# OpenVPN VPC network - 192.168.1.0/24
# Customer VPC network - 10.0.1.0/24

# Used for ec2 instance of OpenVPN AS
module "generate_keys_openvpn" {
  source   = "./modules/generate_keys"
  key_name = "openvpn"
}
# This module creates the OpenVPN VPC and OpenVPN AS server
module "openvpn-vpc" {
  source = "./modules/openvpn_vpc"

  aws_region    = var.openvpn_aws_region
  ami           = var.openvpn_ami
  ec2_user      = var.openvpn_ec2_user
  private_key   = module.generate_keys_openvpn.private_key # Needed for provisioning.
  public_key    = module.generate_keys_openvpn.public_key
  ingress_ports = var.openvpn_ingress_ports
  admin_pass    = var.openvpn_admin_pass
  marti_pass    = var.openvpn_marti_pass
}

# Used for generating customer's ec2 keys
module "generate_keys_customer" {
  source   = "./modules/generate_keys"
  key_name = "customer"
}

# This module is going to run instances that are only accesible though the OpenVPN VPC.
module "customer_vpc" {
  source = "./modules/customer_vpc"

  aws_region    = var.customer_aws_region
  ami           = var.customer_ami
  ec2_user      = var.customer_ec2_user
  public_key    = module.generate_keys_customer.public_key
  ingress_ports = var.customer_ingress_ports
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
  testing_route_table_id = module.customer_vpc.customer_route_table_id
  auto_accept_peering    = true

  tags = {
    Name = "openvpn_customer_peering"
  }
}


resource "null_resource" "vpn_setup" {
  # Copying the .ovpn file to connect to OpenVPN.
  provisioner "local-exec" {
    command = <<EOF
    scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ./private_keys/openvpn_private.key openvpnas@${module.openvpn-vpc.public_dns}:/home/openvpnas/client.ovpn .
    EOF
  }

  depends_on = ["module.openvpn-vpc", "module.generate_keys_openvpn"]
}

module "dns_module" {
  source = "./modules/dns_module"

  public_ip = module.openvpn-vpc.public_ip
  zone_name = var.zone_name

}

module "acme_cert" {
  # This module is used to set up TLS certificate for the web of the OpenVPN AS.
  # This can run in paralell while creating other resources, creating certificates takes time.
  source = "./modules/acme_module"

  email_address = "forregistration@mail.bg"
  use_prod      = true                          # Using prod/staging server
  common_name   = module.dns_module.record_name // This should be depended on DNS module, not wildcard, it is a workaround!!!
}

resource "null_resource" "cert_setup" {
  # Sets up the certificate to OpenVPN AS
  # Implemented this way for training purposes
  connection {
    type        = "ssh"
    host        = module.openvpn-vpc.public_dns
    user        = var.openvpn_ec2_user
    private_key = module.generate_keys_openvpn.private_key
  }

  provisioner "file" {
    source      = "${path.module}/certs/private_key.key"
    destination = "/home/openvpnas/certs/server.key"
  }

  provisioner "file" {
    source      = "${path.module}/certs/server.crt"
    destination = "/home/openvpnas/certs/server.crt"
  }

  provisioner "file" {
    source      = "${path.module}/certs/ca.crt"
    destination = "/home/openvpnas/certs/ca.crt"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /home/openvpnas/certs/server.key /usr/local/openvpn_as/etc/web-ssl/server.key",
      "sudo cp /home/openvpnas/certs/server.crt /usr/local/openvpn_as/etc/web-ssl/server.crt",
      "sudo cp /home/openvpnas/certs/ca.crt /usr/local/openvpn_as/etc/web-ssl/ca.crt",
      "sudo rm /usr/local/openvpn_as/etc/web-ssl/ca.key",
      "sudo systemctl restart openvpnas"
    ]
  }
  depends_on = ["module.acme_cert"]
}

