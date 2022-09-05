terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
    keycloak = {
      source  = "mrparkers/keycloak"
      version = ">= 3.0.0"
    }
  }
}

locals {
  host   = coalesce(var.host, var.service.name)
  domain = "${local.host}.${var.zone}"
}

data "keycloak_realm" "realm" {
  realm = var.keycloak_realm_name
}

resource "keycloak_openid_client" "client" {
  realm_id              = data.keycloak_realm.realm.id
  client_id             = local.domain
  name                  = local.domain
  enabled               = true
  access_type           = "CONFIDENTIAL"
  standard_flow_enabled = true
  valid_redirect_uris = [
    "https://${local.domain}/oauth2/callback"
  ]
}

resource "keycloak_openid_client_default_scopes" "default_client_scopes" {
  realm_id  = data.keycloak_realm.realm.id
  client_id = keycloak_openid_client.client.id

  default_scopes = concat(var.default_client_scopes, [
    "api",
    "profile",
    "email",
    "roles",
    "web-origins"
  ])
}

resource "keycloak_openid_audience_protocol_mapper" "audience_mapper" {
  realm_id                 = data.keycloak_realm.realm.id
  client_id                = keycloak_openid_client.client.id
  included_custom_audience = keycloak_openid_client.client.id
  name                     = "audience"
  add_to_access_token      = true
  add_to_id_token          = false
}

resource "random_password" "cookie_secret" {
  length           = 32
  override_special = "-_"
}

module "proxy_application" {
  source    = "../application"
  name      = "${var.service.name}-proxy"
  namespace = var.service.namespace
  ports     = [4180]
  replicas  = 1
  image     = "quay.io/oauth2-proxy/oauth2-proxy:v7.3.0"
  env_vars = {
    OAUTH2_PROXY_UPSTREAMS              = "http://${var.service.name}.${var.service.namespace}:${var.service.port}/"
    OAUTH2_PROXY_CLIENT_ID              = keycloak_openid_client.client.client_id
    OAUTH2_PROXY_CLIENT_SECRET          = keycloak_openid_client.client.client_secret
    OAUTH2_PROXY_ALLOWED_GROUPS         = join(",", [for g in var.keycloak_groups : "/${g}"])
    OAUTH2_PROXY_REVERSE_PROXY          = "true"
    OAUTH2_PROXY_REAL_CLIENT_IP_HEADER  = "X-Forwarded-For"
    OAUTH2_PROXY_SESSION_COOKIE_MINIMAL = "true"
    OAUTH2_PROXY_COOKIE_EXPIRE          = "168h0m0s"
    OAUTH2_PROXY_COOKIE_NAME            = "_${var.service.name}_oauth2_proxy"
    OAUTH2_PROXY_COOKIE_SECRET          = random_password.cookie_secret.result
    OAUTH2_PROXY_EMAIL_DOMAINS          = "*"
    OAUTH2_PROXY_HTTP_ADDRESS           = "0.0.0.0:4180"
    OAUTH2_PROXY_PROVIDER               = "keycloak-oidc"
    OAUTH2_PROXY_OIDC_ISSUER_URL        = "${var.keycloak_url}/realms/${data.keycloak_realm.realm.realm}"
    OAUTH2_PROXY_SKIP_PROVIDER_BUTTON   = "true"
  }
}

module "proxy_ingress" {
  source             = "../ingress"
  service            = module.proxy_application.service
  host               = local.host
  zone               = var.zone
  path               = var.path
  ingress_class_name = var.ingress_class_name
  annotations        = var.annotations
}
