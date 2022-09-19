output "realms" {
  value = {
    main = keycloak_realm.main
  }
}

output "client_scopes" {
  value = {
    groups = keycloak_openid_client_scope.groups
  }
}
