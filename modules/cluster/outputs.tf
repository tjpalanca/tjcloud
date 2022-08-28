locals {
  kubeconfig = yamldecode(base64decode(linode_lke_cluster.cluster.kubeconfig))
}

output "kubeconfig" {
  value = {
    endpoint               = local.kubeconfig.clusters.0.cluster.server
    token                  = local.kubeconfig.users.0.user.token
    cluster_ca_certificate = base64decode(local.kubeconfig.clusters.0.cluster["certificate-authority-data"])
  }
}

output "voume_mount" {
  value = local.volume_mount
}
