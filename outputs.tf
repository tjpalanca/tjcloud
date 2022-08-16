output "nodes" {
  value     = module.cluster.node_ips
  sensitive = false
}
