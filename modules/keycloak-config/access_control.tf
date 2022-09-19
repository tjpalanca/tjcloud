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
  for_each       = toset(var.settings.admin_emails)
  realm_id       = keycloak_realm.main.id
  username       = each.value
  email          = each.value
  email_verified = true
  enabled        = true
}

resource "keycloak_group_memberships" "admin_users" {
  realm_id = keycloak_realm.main.id
  group_id = keycloak_group.administrator.id
  members = [
    for user in keycloak_user.admin_users : user.username
  ]
}

resource "keycloak_group_memberships" "developer_users" {
  realm_id = keycloak_realm.main.id
  group_id = keycloak_group.developer.id
  members = [
    for user in keycloak_user.admin_users : user.username
  ]
}

resource "keycloak_group_memberships" "tester_users" {
  realm_id = keycloak_realm.main.id
  group_id = keycloak_group.tester.id
  members = [
    for user in keycloak_user.admin_users : user.username
  ]
}
