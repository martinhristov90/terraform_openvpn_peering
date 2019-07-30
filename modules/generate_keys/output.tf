output "public_key" {
  value = tls_private_key.keys.public_key_openssh
}

output "private_key" {
  value = tls_private_key.keys.private_key_pem
}
