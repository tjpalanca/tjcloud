output "kubeconfig" {
  value     = module.cluster.kubeconfig
  sensitive = true
}
