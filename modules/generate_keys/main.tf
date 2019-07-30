resource "tls_private_key" "keys" {
  algorithm   = "RSA"
  ecdsa_curve = "2048"
}

resource "local_file" "key_save_private" {
  sensitive_content = "${tls_private_key.keys.private_key_pem}" # Not printing the content in outputs.
  filename          = "${path.module}/../../private_keys/${var.key_name}_private.key"

  provisioner "local-exec" {
    command = "chmod 400 ${path.module}/../../private_keys/${var.key_name}_private.key"
  }
}

