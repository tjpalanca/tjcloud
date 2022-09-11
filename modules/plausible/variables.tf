variable "google_client_id" {
  type = string
}

variable "google_client_secret" {
  type = string
}

variable "postgres" {}

variable "clickhouse" {}

variable "smtp_host" {
  type = string
}

variable "subdomain" {
  type = string
}

variable "cloudflare_zone" {
  type = string
}

variable "main_cloudflare_zone" {
  type = string
}

variable "admin_user" {}

variable "secret_key_base" {
  type = string
}
