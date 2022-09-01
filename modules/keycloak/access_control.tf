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
