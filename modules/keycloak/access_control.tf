resource "keycloak_group" "administrator" {
  realm_id = keycloak_realm.main.id
  name     = "Administrator"
}

resource "keycloak_group" "developer" {
  realm_id = keycloak_realm.main.id
  name     = "Developer"
}

resource "keycloak_group" "tester" {
  realm_id = keycloak_realm.main.id
  name     = "Tester"
}

resource "keycloak_user" "admin_users" {
  for_each = var.admin_emails
  realm_id = keycloak_realm.main.id
  username = each.value
  enabled  = true
  email    = each.value
}

resource "keycloak_group_memberships" "admin_users" {
  realm_id = keycloak_realm.realm.id
  group_id = keycloak_group.administrator.id
  members  = var.admin_emails
}
