variable "server_type" {
  type        = map(string)
  description = "Determines whether to use prod or stage server of Let's encrypt"
  default = {
    prod  = "https://acme-v02.api.letsencrypt.org/directory"
    stage = "https://acme-staging-v02.api.letsencrypt.org/directory"
  }
}

variable "use_prod" {
  description = "Which server to use"
  default     = false
}

variable "email_address" {
  type        = string
  description = "Registration mail for creating Lets Encrypt account"
}

variable "common_name" {
  description = "Common name for the certificate"
}


