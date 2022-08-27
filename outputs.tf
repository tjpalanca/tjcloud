output "kubeconfig" {
  value     = nonsensitive(module.cluster.kubeconfig)
  sensitive = false
}
