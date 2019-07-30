# The issuance of certificate by Lets Encrypt can be devided into two steps, first - register account, second - issueing certificate.
locals {
  server_url = var.use_prod == true ? var.server_type["prod"] : var.server_type["stage"]
}


provider "acme" {
  # Production endpoint for Let's Encrypt
  # There are two choices prod or stage, for making the issuence of the certificate work, stage can be used at first, when it works, switch to prod.
  # Certificates by stage server are not trusted by any browser.
  server_url = local.server_url
}

resource "tls_private_key" "private_key" {
  # This is the private key.
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  # Creating an account
  account_key_pem = "${tls_private_key.private_key.private_key_pem}"
  email_address   = var.email_address
}

resource "acme_certificate" "certificate" {
  # Actually completing the DNS-01 challange and issuing certificate. Demonstrating that we have control over the domain.
  account_key_pem = "${acme_registration.reg.account_key_pem}"
  common_name     = var.common_name # Wildcart certificate
  //subject_alternative_names = ["marti.martinhristov.xyz"]

  dns_challenge {
    provider = "route53"
  }
}

# Outputs the private key to project_root/certs/private_key.key
resource "local_file" "private_key" {
  sensitive_content = "${acme_certificate.certificate.private_key_pem}" # Not printing the content in outputs.
  filename          = "${path.module}/../../certs/private_key.key"
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
