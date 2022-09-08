variable "cloudflare_zone" {
  type = string
}

variable "versioned_image" {
  type = string
}

variable "node_name" {
  type = string
}

variable "user_name" {
  type = string
}

variable "github_pat" {
  type = string
}

variable "extensions_gallery_json" {
  type = string
}

variable "node_password" {}
variable "node_ip_address" {}
variable "volume_name" {}

variable "keycloak_realm_name" {}
variable "keycloak_url" {}
variable "default_client_scopes" {}
