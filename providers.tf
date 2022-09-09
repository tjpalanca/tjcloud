provider "linode" {
  token = var.linode_token
}

provider "cloudflare" {
  api_token            = var.cloudflare_api_token
  api_user_service_key = var.cloudflare_origin_ca_key
}

provider "kubernetes" {
  host                   = module.cluster.kubeconfig.endpoint
  token                  = module.cluster.kubeconfig.token
  cluster_ca_certificate = module.cluster.kubeconfig.cluster_ca_certificate
}

provider "postgresql" {
  alias           = "main"
  host            = module.database.main_postgres_database_credentials.external_host
  port            = module.database.main_postgres_database_credentials.external_port
  database        = module.database.main_postgres_database_credentials.database
  username        = module.database.main_postgres_database_credentials.username
  password        = module.database.main_postgres_database_credentials.password
  sslmode         = "disable"
  connect_timeout = 15
}

# provider "keycloak" {
#   client_id = "admin-cli"
#   username  = var.keycloak_admin_username
#   password  = var.keycloak_admin_password
#   url       = module.keycloak.url
#   base_path = ""
# }
