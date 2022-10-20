variable "namespace" {
  type    = string
  default = "kubernetes-dashboard"
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
