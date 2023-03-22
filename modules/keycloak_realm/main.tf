terraform {
  required_providers {
    keycloak = {
      source  = "mrparkers/keycloak"
      version = "~> 4.0.1"
    }
  }
}

resource "keycloak_realm" "realm" {
  realm             = var.name
  display_name      = var.name
  display_name_html = var.name_html
  login_theme       = var.login_theme
}
