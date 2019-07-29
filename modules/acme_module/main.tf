provider "acme" {
  # Production endpoint for Let's Encrypt
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = "${tls_private_key.private_key.private_key_pem}"
  email_address   = "forregistration@mail.bg"
}

resource "acme_certificate" "certificate" {
  account_key_pem = "${acme_registration.reg.account_key_pem}"
  common_name     = "*.martinhristov.xyz"
  //subject_alternative_names = ["marti.martinhristov.xyz"]

  dns_challenge {
    provider = "route53"
  }
}

# Outputs the private key to project_root/certs/private_key.key
resource "local_file" "private_key" {
  content  = "${acme_certificate.certificate.private_key_pem}"
  filename = "${path.module}/../../certs/private_key.key"
}
# Outputs the server's certificate (public key) to file named
resource "local_file" "certificate_pem" {
  content  = "${acme_certificate.certificate.certificate_pem}"
  filename = "${path.module}/../../certs/server.crt"
}

# Outputs the CA cert to file named ca.crt
resource "local_file" "issuer_pem" {
  content  = "${acme_certificate.certificate.issuer_pem}"
  filename = "${path.module}/../../certs/ca.crt"
}
