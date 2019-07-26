variable "aws_region" {
  description = "aws region for openpnv VPC"
}

variable "ami" {
  description = "AMI to be used in openvpn VPC"
}

variable "ec2_user" {
  description = "User to connect to the OpenVPN AS instance"
}

variable "private_key" {
  description = "Private key to connect to the OpenVPN AS instance"
}

variable "public_key" {
  description = "Public key to generated the key pair used in OpenVPN AS instance"
}

variable "ingress_ports" {
  description = "Ports to be opened in the SG"
}

variable "admin_pass" {
  description = "Password for user admin"
}

variable "marti_pass" {
  description = "Password for user marti"
}

