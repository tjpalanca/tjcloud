resource "keycloak_authentication_flow" "autolink" {
  realm_id = keycloak_realm.realm.id
  alias    = "autolink"
}

resource "keycloak_authentication_execution" "review_profile" {
  realm_id          = keycloak_realm.realm.id
  parent_flow_alias = keycloak_authentication_flow.autolink.alias
  authenticator     = "idp-review-profile"
  requirement       = "REQUIRED"
}

resource "keycloak_authentication_subflow" "create_or_link_user" {
  realm_id          = keycloak_realm.realm.id
  alias             = "Create or link user"
  parent_flow_alias = keycloak_authentication_flow.autolink.alias
  provider_id       = "basic-flow"
  requirement       = "REQUIRED"
  depends_on = [
    keycloak_authentication_execution.review_profile
  ]
}

resource "keycloak_authentication_execution" "create_user_if_unique" {
  realm_id          = keycloak_realm.realm.id
  parent_flow_alias = keycloak_authentication_subflow.create_or_link_user.alias
  authenticator     = "idp-create-user-if-unique"
  requirement       = "ALTERNATIVE"
  depends_on = [
    keycloak_authentication_subflow.create_or_link_user
  ]
}

resource "keycloak_authentication_subflow" "handle_an_existing_account" {
  realm_id          = keycloak_realm.realm.id
  alias             = "Handle an existing account"
  parent_flow_alias = keycloak_authentication_subflow.create_or_link_user.alias
  provider_id       = "basic-flow"
  requirement       = "ALTERNATIVE"
  depends_on = [
    keycloak_authentication_execution.create_user_if_unique
  ]
}

resource "keycloak_authentication_execution" "confirm_link_existing_account" {
  realm_id          = keycloak_realm.realm.id
  parent_flow_alias = keycloak_authentication_subflow.handle_an_existing_account.alias
  authenticator     = "idp-confirm-link"
  requirement       = "ALTERNATIVE"
  depends_on = [
    keycloak_authentication_subflow.handle_an_existing_account
  ]
}

resource "keycloak_authentication_execution" "automatically_set_existing_user" {
  realm_id          = keycloak_realm.realm.id
  parent_flow_alias = keycloak_authentication_subflow.handle_an_existing_account.alias
  authenticator     = "idp-auto-link"
  requirement       = "REQUIRED"
  depends_on = [
    keycloak_authentication_execution.confirm_link_existing_account
  ]
}
