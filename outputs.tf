output "instances" {
  value     = module.cluster.instance_data
  sensitive = false
}
