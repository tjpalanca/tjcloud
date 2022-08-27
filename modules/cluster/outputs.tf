locals {
  kubeconfig = yamldecode(base64decode(linode_lke_cluster.cluster.kubeconfig))
}

output "kubeconfig" {
  value = {
    endpoint = local.kubeconfig.clusters.0.cluster.server
    token    = local.kubeconfig.users.0.user.token
    # cluster_ca_certificate = local.kubeconfig.clusters.0.cluster.server
  }
}
