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
    image                = string
    subdomain            = string
    cloudflare_zone_id   = string
    cloudflare_zone_name = string
  })
}

variable "admin" {
  type = object({
    username = string
    password = string
  })
}
