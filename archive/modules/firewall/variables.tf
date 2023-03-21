variable "name" {
  type        = string
  description = "Name of the firewall"
}

variable "node_ids" {
  type        = list(string)
  description = "List of node IDs to apply this firewall to"
}

variable "allowed_ips" {
  type        = list(string)
  description = "IP addresses to allow access to the cluster"
}
