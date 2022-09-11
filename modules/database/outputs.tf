output "main_postgres_credentials" {
  value = module.main_postgres_database.credentials
}

output "main_clickhouse_credentials" {
  value = module.main_clickhouse_database.credentials
}
