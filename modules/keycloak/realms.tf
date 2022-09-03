resource "keycloak_realm" "main" {
  realm        = var.settings.realm_name
  display_name = var.settings.realm_display_name
  login_theme  = "social"
  depends_on = [
    module.keycloak_application
  ]
}
