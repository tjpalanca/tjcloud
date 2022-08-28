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

output "main_node" {
  value = data.linode_instances.main_nodes.instances.0
}

output "main_nodes" {
  value = data.linode_instances.main_nodes.instances
}

output "local_storage_class" {
  value = kubernetes_storage_class_v1.local_storage
}
