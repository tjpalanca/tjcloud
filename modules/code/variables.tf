variable "cloudflare_zone_id" {
  type = string
}

variable "cloudflare_zone_name" {
  type = string
}

variable "image" {
  type = string
}

variable "node_name" {
  type = string
}

variable "user_name" {
  type = string
}

variable "code_font" {
  type = string
}

variable "github_pat" {
  type = string
}

variable "extensions_gallery_json" {
  type = string
}

variable "node_password" {
  type = string
}
variable "node_ip_address" {
  type = string
}
variable "volume_name" {
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
