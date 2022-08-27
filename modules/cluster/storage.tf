resource "linode_volume" "cluster_data" {
  label     = "${var.cluster_name}-data"
  region    = var.linode_region
  linode_id = linode_lke_cluster.cluster.pool.0.nodes.0.instance_id
  size      = 10
}
