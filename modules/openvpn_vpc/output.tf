output "public_dns" {
  description = "Outputs the public IP of the created instance"
  value       = aws_eip.open-vpn-eip.public_dns
}

output "public_ip" {
  description = "Outputs the public IP of the created instance"
  value       = aws_eip.open-vpn-eip.public_ip
}

output "open_vpn_vpc_id" {
  description = "Outputs ID of the VPC in which OpenVPN is running"
  value       = aws_vpc.openvpn-vpc.id
}

output "openvpn_route_table_id" {
  description = "Outputs the ID of the route table"
  value       = aws_route_table.openvpn-vpc-route-table.id
}