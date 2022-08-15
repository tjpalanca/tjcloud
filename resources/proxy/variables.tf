variable "upstream" {
  type = object({
    name    = string
    address = string
  })
  description = "Details about the upstream application"
}

variable "config" {
  type = object({
    port                    = number
    keycloak_client_id      = string
    keycloak_client_secret  = string
    keycloak_allowed_groups = string
    keycloak_domain         = string
    email_domains           = string
    cookie_secret           = string
  })
  default = {
    port                    = 4180
    keycloak_allowed_groups = ""
    email_domains           = "*"
  }
  description = "Proxy configuration"
}
