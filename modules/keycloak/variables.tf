variable "database" {
  type = object({
    username      = string
    password      = string
    internal_name = string
    internal_port = string
  })
}

variable "keycloak" {
  type = object({
    image           = string
    subdomain       = string
    cloudflare_zone = string
  })
}

variable "admin" {
  type = object({
    username = string
    password = string
  })
}

variable "settings" {
  type = object({
    realm_name   = string
    admin_emails = list(string)
    display_name = string
  })
}

variable "identity_providers" {
  type = object({
    google = object({
      client_id     = string
      client_secret = string
    })
  })
}
