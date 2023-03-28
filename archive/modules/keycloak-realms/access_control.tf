resource "keycloak_group" "administrator" {
  realm_id = module.main.realm.id
  name     = "Administrator"
}

resource "keycloak_group" "developer" {
  realm_id = module.main.realm.id
  name     = "Developer"
}

resource "keycloak_group" "tester" {
  realm_id = module.main.realm.id
  name     = "Tester"
}

resource "keycloak_user" "admin_users" {
  for_each       = toset(var.admin_emails)
  realm_id       = module.main.realm.id
  username       = each.value
  email          = each.value
  email_verified = true
  enabled        = true
}

resource "keycloak_group_memberships" "admin_users" {
  realm_id = module.main.realm.id
  group_id = keycloak_group.administrator.id
  members = [
    for user in keycloak_user.admin_users : user.username
  ]
}

resource "keycloak_group_memberships" "developer_users" {
  realm_id = module.main.realm.id
  group_id = keycloak_group.developer.id
  members = [
    for user in keycloak_user.admin_users : user.username
  ]
}

resource "keycloak_group_memberships" "tester_users" {
  realm_id = module.main.realm.id
  group_id = keycloak_group.tester.id
  members = [
    for user in keycloak_user.admin_users : user.username
  ]
}
