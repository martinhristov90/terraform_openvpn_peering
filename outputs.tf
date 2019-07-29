output "openvpn_public_dns" {
  value = module.openvpn-vpc.public_dns
}

output "ec2_nginx_private_up" {
  value = module.customer_vpc.private_ip
}

output "openvpn_public_ip" {
  value = module.openvpn-vpc.public_ip
}
