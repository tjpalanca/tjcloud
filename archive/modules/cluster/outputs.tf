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

output "main_node_volume" {
  value = linode_volume.main_node_volume
}

output "node_ids" {
  value = [for node in linode_lke_cluster.cluster.pool.0.nodes : node.instance_id]
}
