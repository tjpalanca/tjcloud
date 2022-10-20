terraform {
  required_providers {
    keycloak = {
      source  = "mrparkers/keycloak"
      version = "~> 4.0.1"
    }
  }
}

module "main" {
  source      = "../../elements/keycloak_realm"
  name        = "tjcloud"
  name_html   = "<div class='logo-text'><img style='max-height: 120px;' src='https://tjpalanca.com/assets/logo/logo-small.png'></div>"
  login_theme = "social"
  google      = var.google
}
