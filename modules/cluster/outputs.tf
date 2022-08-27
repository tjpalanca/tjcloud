output "kubeconfig" {
  value = base64decode(linode_lke_cluster.cluster.kubeconfig)
}
