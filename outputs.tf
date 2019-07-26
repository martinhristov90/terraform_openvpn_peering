output "openvpn_public_dns" {
  value = module.openvpn-vpc.public_ip
}

output "ec2_nginx_private_up" {
  value = module.customer_vpc.private_ip
}

