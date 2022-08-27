variable "cluster_name" {
  type        = string
  description = "DOKS Cluster Name"
}

variable "do_token" {
  type        = string
  description = "DigitalOcean token"
}

variable "do_region" {
  type        = string
  default     = "sgp1"
  description = "Main DigitalOcean region"
}

variable "linode_token" {
  type        = string
  description = "Linode API Token"
}

variable "linode_region" {
  type        = string
  default     = "ap-south"
  description = "Main Linode region"
}

variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API Token"
}

variable "main_cloudflare_zone" {
  type        = string
  description = "Zone at which the cluster ingress will be exposed"
}

variable "main_postgres_username" {
  type        = string
  description = "Username for the main postgres database"
}

variable "main_postgres_password" {
  type        = string
  description = "Password for the main postgres database"
}

variable "main_postgres_database" {
  type        = string
  description = "Main postgres database"
}

variable "pgadmin_default_username" {
  type        = string
  description = "PGAdmin initialized username"
}

variable "pgadmin_default_password" {
  type        = string
  description = "PGAdmin initialized password"
}
