variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API Token"
}

variable "cloudflare_account_id" {
  type        = string
  description = "Cloudflare Account ID"
}

variable "cloudflare_origin_ca_key" {
  type        = string
  description = "For Origin Certificates"
}

variable "controller_version" {
  type    = string
  default = "1.3.1"
}

variable "certgen_version" {
  type    = string
  default = "1.3.0"
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

variable "do_token" {
  type        = string
  description = "DigitalOcean API Token"
}

variable "do_region" {
  type        = string
  description = "Default region in which to deploy resources"
}

variable "admin_emails" {
  type        = list(string)
  description = "Emails for administrators"
}

variable "r2_access_key" {
  type        = string
  description = "Cloudflare R2 access key"
}

variable "r2_secret_key" {
  type        = string
  description = "Cloudflare R2 secret key"
}

variable "user_name" {
  type        = string
  description = "General user name"
}
