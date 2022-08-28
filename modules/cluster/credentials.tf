resource "null_resource" "reset_root_password" {

  for_each = local.main_nodes

  provisioner "local-exec" {
    command = <<EOF
      sleep 10 && \
      curl -H "Content-Type: application/json" \
        -H "Authorization: Bearer $TOKEN" \
        -X POST \
        https://api.linode.com/v4/linode/instances/${each.value.id}/shutdown && \
      sleep 30 && \
      curl -H "Content-Type: application/json" \
        -H "Authorization: Bearer $TOKEN" \
        -X POST -d "{\"password\": \"$PASSWORD\"}" \
        https://api.linode.com/v4/linode/instances/${each.value.id}/disks/${each.value.disk.0.id}/password && \
      sleep 5 && \
      curl -H "Content-Type: application/json" \
        -H "Authorization: Bearer $TOKEN" \
        -X POST \
        https://api.linode.com/v4/linode/instances/${each.value.id}/boot
    EOF
    environment = {
      TOKEN    = var.linode_token
      PASSWORD = var.root_password
    }
  }

}

resource "null_resource" "add_local_ssh_key" {

  for_each = local.main_nodes

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = var.root_password
      host     = each.value.ip_address
    }
    inline = [
      "echo ${var.local_ssh_key} > ~/.ssh/authorized_keys"
    ]
  }

}
