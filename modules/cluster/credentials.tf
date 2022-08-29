resource "null_resource" "reset_root_password" {

  count = var.num_main_nodes

  depends_on = [
    time_sleep.cluster_created
  ]

  provisioner "local-exec" {
    command = <<EOF
      curl -H "Content-Type: application/json" \
        -H "Authorization: Bearer $TOKEN" \
        -X POST \
        https://api.linode.com/v4/linode/instances/${data.linode_instances.main_nodes.instances[count.index].id}/shutdown && \
      sleep 30 && \
      curl -H "Content-Type: application/json" \
        -H "Authorization: Bearer $TOKEN" \
        -X POST -d "{\"root_pass\": \"$PASSWORD\"}" \
        https://api.linode.com/v4/linode/instances/${data.linode_instances.main_nodes.instances[count.index].id}/password && \
      sleep 5 && \
      curl -H "Content-Type: application/json" \
        -H "Authorization: Bearer $TOKEN" \
        -X POST \
        https://api.linode.com/v4/linode/instances/${data.linode_instances.main_nodes.instances[count.index].id}/boot
    EOF
    environment = {
      TOKEN    = nonsensitive(var.linode_token)
      PASSWORD = nonsensitive(var.root_password)
    }
  }

}

resource "null_resource" "add_local_ssh_key" {

  count = var.num_main_nodes

  depends_on = [
    null_resource.reset_root_password
  ]

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = var.root_password
      host     = data.linode_instances.main_nodes.instances[count.index].ip_address
    }
    inline = [
      "echo ${var.local_ssh_key} > ~/.ssh/authorized_keys"
    ]
  }

}

resource "time_sleep" "cluster_ready" {
  depends_on = [
    null_resource.add_local_ssh_key,
    null_resource.reset_root_password
  ]
  create_duration = "60s"
}
