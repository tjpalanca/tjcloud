variable "pgadmin_default_username" {
  type = string
}

variable "pgadmin_default_password" {
  type = string
}

variable "cloudflare_zone_id" {
  type = string
}

variable "cloudflare_zone_name" {
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

variable "volume_name" {
  type = string
}

variable "node_password" {
  type = string
}

variable "node_ip_address" {
  type = string
}

variable "node_name" {
  type = string
}
