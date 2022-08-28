output "instances" {
  value     = nonsensitive(module.cluster.instance_data)
  sensitive = false
}
