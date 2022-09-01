resource "keycloak_oidc_google_identity_provider" "google" {
  realm         = keycloak_realm.main.id
  client_id     = var.identity_providers.google.client_id
  client_secret = var.identity_providers.google.client_secret
  trust_email   = true
  hosted_domain = "*"
  sync_mode     = "IMPORT"
}
