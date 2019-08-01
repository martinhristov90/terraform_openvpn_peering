output "openvpn_public_dns" {
  value = module.openvpn-vpc.public_dns
}

output "ec2_nginx_private_ip" {
  value = module.customer_vpc.private_ip
}

output "openvpn_public_ip" {
  value = module.openvpn-vpc.public_ip
}

output "domain" {
  value = "You should be able to reach the OpenVPN server at the domain name you provided"
}
