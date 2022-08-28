# data "cloudflare_zone" "main" {
#   name = var.cloudflare_zone
# }

# resource "cloudflare_record" "main_nodes" {
#   count   = var.num_main_nodes
#   zone_id = data.cloudflare_zone.main.zone_id
#   name    = "@"
#   value   = local.main_nodes[count.index].ip_address
#   type    = "A"
#   proxied = true
#   depends_on = [
#     linode_lke_cluster.cluster
#   ]
# }
