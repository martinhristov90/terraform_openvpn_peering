variable "aws_region" {
  description = "aws region for customer VPC"
}
variable "ami" {
  description = "AMI to be used in customer VPC"
}

variable "ec2_user" {
  description = "User to connect to the instance, not used currently"
}

variable "private_key" {
  description = "Private key to connect to the instance,  not used currently"
}

variable "public_key" {
  description = "Public key used to create the aws key pair"
}

