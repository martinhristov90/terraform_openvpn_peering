# Variables for openvpn VPC
variable "openvpn_aws_region" {
  default = "us-east-1"
}

variable "openvpn_ami" {
  type = map(string)
  default = {
    us-east-1 = "ami-07a8d85046c8ecc99" # OpenVPN AS AMI
  }
}

variable "openvpn_ec2_user" {
  default = "openvpnas"
}

variable "openvpn_ingress_ports" {
  type        = list(number)
  description = "list of ingress ports"
  default     = [22, 80, 443, 943, 1194]
}

# Misc settings

variable "openvpn_admin_pass" {
  default = "openvpn123"
}

variable "openvpn_marti_pass" {
  default = "marti123"
}


#### customer_vpc module vars


variable "customer_aws_region" {
  default = "us-east-1"
}

variable "customer_ami" {
  type = map(string)
  default = {
    us-east-1 = "ami-03efe20853d0a91d5" //"ami-0cfee17793b08a293"
  }
}

variable "customer_ec2_user" {
  default = "ubuntu"
}

variable "customer_ingress_ports" {
  type        = list(number)
  description = "ingress ports for customer ssh_http_allowed SG"
  default     = [22, 80]

}



