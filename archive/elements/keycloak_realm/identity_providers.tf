resource "keycloak_oidc_google_identity_provider" "google" {
  realm                         = keycloak_realm.realm.id
  client_id                     = var.google.client_id
  client_secret                 = var.google.client_secret
  trust_email                   = true
  hosted_domain                 = ""
  sync_mode                     = "IMPORT"
  store_token                   = false
  first_broker_login_flow_alias = keycloak_authentication_flow.autolink.alias
}
