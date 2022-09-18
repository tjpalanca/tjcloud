output "url" {
  value = "https://${var.keycloak.subdomain}.${data.cloudflare_zone.zone.name}"
}
