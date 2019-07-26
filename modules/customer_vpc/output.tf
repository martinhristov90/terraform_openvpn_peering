output "public_ip" {
  description = "Outputs the public IP of the created instance"
  value       = aws_instance.web.public_ip
}

output "customer_vpc_id" {
  description = "Outputs the customer VPC ID"
  value       = aws_vpc.main.id
}

output "private_ip" {
  description = "Outputs the private IP of the EC2"
  value       = aws_instance.web.private_ip
}