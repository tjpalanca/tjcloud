resource "keycloak_realm" "main" {
  realm        = var.settings.realm_name
  display_name = var.settings.display_name
}
