output "url" {
  value = "https://${var.keycloak.subdomain}.${var.keycloak.cloudflare_zone_name}"
}
