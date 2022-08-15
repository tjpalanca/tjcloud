variable "do_token" {
  type        = string
  description = "DigitalOcean Access Token"
}

variable "cluster_name" {
  type        = string
  description = "Name of kubernetes cluster"
}

variable "main_postgres_password" {
  type        = string
  description = "Main postgres password"
}
