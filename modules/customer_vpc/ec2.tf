resource "aws_instance" "web" {
  # Run this particular Ubuntu AMI
  ami = var.ami[var.aws_region]
  # Subnet ID this instance to be associated with
  subnet_id = aws_subnet.main.id
  # What SGs to apply to this instance
  vpc_security_group_ids = [aws_security_group.ssh_http_allowed.id]
  # ID of the key pair to be used to access this instance, only accesible though OpenVPN
  key_name = aws_key_pair.deployer.id
  # Size of the instance
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld_ec2"
  }
}

# Key pair to be used with the EC2 instance.
resource "aws_key_pair" "deployer" {
  key_name   = "aws_key_pair"
  public_key = var.public_key
}

