variable "cluster_name" {
  type = string
}

variable "num_main_nodes" {
  type    = number
  default = 1
}

variable "linode_region" {
  type = string
}

variable "linode_token" {
  type = string
}

variable "root_password" {
  type = string
}

variable "local_ssh_key" {
  type = string
}

variable "cloudflare_zone" {
  type = string
}

variable "cloudflare_origin_ca" {
  type = object({
    private_key      = string
    private_key_algo = string
    common_name      = string
    organization     = string
  })
}
