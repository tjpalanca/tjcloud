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
    version   = string
    subdomain = string
    admin = object({
      username = string
      password = string
    })
    cloudflare_zone = string
    settings = object({
      realm_name = string
    })
  })
}
