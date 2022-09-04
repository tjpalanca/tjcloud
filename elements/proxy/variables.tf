variable "service" {
  type = object({
    name      = string
    port      = number
    namespace = string
  })
  description = "Details about the upstream service"
}

variable "config" {
  type = object({
    keycloak_client_id      = string
    keycloak_client_secret  = string
    keycloak_allowed_groups = string
    cookie_secret           = string
  })
  description = "Proxy configuration"
}
