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
    version = string
    admin = object({
      username = string
      password = string
    })
    cloudflare_zone = string
  })
}
