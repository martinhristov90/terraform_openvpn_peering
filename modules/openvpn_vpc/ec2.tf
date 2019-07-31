resource "aws_instance" "openvpn-ec2" {
  # Run this particular Ubuntu AMI
  ami = var.ami[var.aws_region]
  # Subnet ID this instance to be associated with, this subnet is going to have the routes inherited from default route table for the VPC.
  subnet_id = aws_subnet.openvpn-subnet.id
  # What SGs to apply to this instance
  vpc_security_group_ids = [aws_security_group.openvpn_sg.id]
  # ID of the key pair to be used to access this instance
  key_name = aws_key_pair.openvpn-keypair.id
  # Size of the instance
  instance_type = "t2.micro"
  # This connection is needed to run remote-exec provisioner
  user_data = templatefile("${path.module}/ovpn_config/provision.tmpl", { marti_pass = var.marti_pass, admin_pass = var.admin_pass })

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
  connection {
    type        = "ssh"
    host        = aws_eip.open-vpn-eip.public_dns
    user        = var.ec2_user
    private_key = var.private_key
  }
  # The dafault route of the clients is not going to be changed, DNS requests are not going though the tunnel.
  # User admin is going to be created, user openvpn is going to be deleted. Passwords for both users marti and admin are defined in vars.  provisioner "remote-exec" {
  provisioner "remote-exec" {
    inline = [
      # Dirty trick, to wait for user_data to finish
      "cloud-init status --wait"
    ]
  }
  depends_on = ["aws_instance.openvpn-ec2", "aws_eip.open-vpn-eip"]
}
