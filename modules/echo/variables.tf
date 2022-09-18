variable "cloudflare_zone_id" {
  type = string
}

variable "keycloak_realm_id" {
  type = string
}

variable "keycloak_url" {
  type = string
}

variable "default_client_scopes" {
  type = list(string)
}
