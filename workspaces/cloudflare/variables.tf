variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API Token"
}

variable "cloudflare_account_id" {
  type        = string
  description = "Cloudflare Account ID"
}

variable "dev_zone_id" {
  type        = string
  description = "Development Zone ID"
}

variable "dev_zone_name" {
  type        = string
  description = "Development TLD"
}

variable "com_zone_id" {
  type        = string
  description = "Public Zone ID"
}

variable "com_zone_name" {
  type        = string
  description = "Public TLD"
}

variable "cloudflare_origin_ca_key" {
  type        = string
  description = "For Origin Certificates"
}

variable "github_client_id" {
  type        = string
  description = "GitHub Login"
}

variable "github_client_secret" {
  type        = string
  description = "GitHub Login"
}

variable "google_client_id" {
  type        = string
  description = "Google Login"
}

variable "google_client_secret" {
  type        = string
  description = "Google Login"
}
