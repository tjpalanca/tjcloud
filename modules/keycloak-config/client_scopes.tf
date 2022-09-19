resource "keycloak_openid_client_scope" "groups" {
  realm_id               = keycloak_realm.main.id
  name                   = "groups"
  description            = "Map a user's group memberships to a claim"
  include_in_token_scope = true
}
