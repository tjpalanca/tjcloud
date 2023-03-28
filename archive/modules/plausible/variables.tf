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

variable "cloudflare_zone_id" {
  type = string
}

variable "cloudflare_zone_name" {
  type = string
}

variable "cloudflare_zone_cname" {
  type = string
}

variable "secret_key_base" {
  type = string
}

variable "plausible_version" {
  type = string 
  default = "1.5.1"
}
