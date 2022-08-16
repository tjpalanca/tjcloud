variable "do_token" {
  type        = string
  description = "DigitalOcean Access Token"
}

variable "main_postgres_password" {
  type        = string
  description = "Main postgres password"
}

variable "cloudflare_api_token" {
  type        = string
  description = "API Token for Cloudflare Services"
}
