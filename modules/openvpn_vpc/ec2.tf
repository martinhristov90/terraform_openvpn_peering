resource "aws_instance" "openvpn-ec2" {
  # Run this particular Ubuntu AMI
  ami = var.ami[var.aws_region]
  # Subnet ID this instance to be associated with
  subnet_id = aws_subnet.openvpn-subnet.id
  # What SGs to apply to this instance
  vpc_security_group_ids = [aws_security_group.ssh_http_allowed.id]
  # ID of the key pair to be used to access this instance
  key_name = aws_key_pair.openvpn-keypair.id
  # Size of the instance
  instance_type = "t2.micro"
  # This connection is needed to run remote-exec provisioner

  tags = {
    Name = "openvpn_as"
  }
}

# Key pair to be used with the EC2 instance.
resource "aws_key_pair" "openvpn-keypair" {
  key_name   = "aws_key_pair_openvpn"
  public_key = var.public_key
}

resource "null_resource" "vpn_setup" {
  triggers = {
    aws_instance_id = aws_instance.openvpn-ec2.id
  }

    connection {
    type        = "ssh"
    host        = aws_eip.open-vpn-eip.public_dns
    user        = var.ec2_user
    private_key = var.private_key
  }

  provisioner "remote-exec" {
    inline = [
      "sudo ovpn-init --ec2 --batch --force",
      "sleep 4",
      "sudo /usr/local/openvpn_as/scripts/sacli -u marti -k type -v user_connect UserPropPut",
      "sudo /usr/local/openvpn_as/scripts/sacli -u marti --new_pass ${var.marti_pass} SetLocalPassword",
      "sudo /usr/local/openvpn_as/scripts/sacli -k vpn.server.routing.private_network.1 -v 10.0.0.0/16 ConfigPut",
      "sudo /usr/local/openvpn_as/scripts/sacli -k vpn.server.routing.private_network.1 -v 10.0.1.0/24 ConfigPut",
      "sudo /usr/local/openvpn_as/scripts/sacli -u admin -k prop_superuser -v true UserPropPut",
      "sudo /usr/local/openvpn_as/scripts/sacli -u admin --new_pass ${var.admin_pass} SetLocalPassword",
      "sudo /usr/local/openvpn_as/scripts/sacli -k vpn.client.routing.reroute_gw -v false ConfigPut",
      "sudo /usr/local/openvpn_as/scripts/sacli -k host.name -v ${aws_eip.open-vpn-eip.public_dns} ConfigPut",
      "sleep 4",
      "sudo systemctl restart openvpnas",
      "sleep 2"
    ]
  }
  
  depends_on = ["aws_instance.openvpn-ec2", "aws_eip.open-vpn-eip"]

}
