output "url" {
  value = "https://${var.keycloak.subdomain}.${var.keycloak.cloudflare_zone}"
}

output "realms" {
  value = {
    main = keycloak_realm.main
  }
}
