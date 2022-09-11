module "plausible" {
  source = "./modules/plausible"
  providers = {
    postgresql = postgresql.main
  }
  postgres             = module.database.main_postgres_credentials
  plausible            = module.database.main_clickhouse_credentials
  google_client_id     = var.google_client_id
  google_client_secret = var.google_client_secret
}
