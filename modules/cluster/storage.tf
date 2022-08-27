locals {
  main_node = data.linode_instances.production_nodes.0.instances.0
  volume_name = "${var.cluster_name}-data"
}

resource "linode_volume" "cluster_data" {
  label     = local.volume_name
  region    = var.linode_region
  linode_id = local.main_node.id

  provisioner "local-exec" {
    command = <<EOF
      sleep 10 && \
      curl -H "Content-Type: application/json" \
        -H "Authorization: Bearer $TOKEN" \
        -X POST \
        https://api.linode.com/v4/linode/instances/${local.main_node.id}/shutdown && \
      sleep 30 && \
      curl -H "Content-Type: application/json" \
        -H "Authorization: Bearer $TOKEN" \
        -X POST -d "{\"password\": \"$PASSWORD\"}" \
        https://api.linode.com/v4/linode/instances/${local.main_node.id}/disks/${local.main_node.disk.0.id}/password && \
      sleep 5 && \
      curl -H "Content-Type: application/json" \
        -H "Authorization: Bearer $TOKEN" \
        -X POST \
        https://api.linode.com/v4/linode/instances/${local.main_node.id}/boot
    EOF
    environment = {
      TOKEN    = var.linode_token
      PASSWORD = var.root_password
    }
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = var.root_password
      host     = local.main_node.ip_address
    }
    inline = [
      "export DEVICE='${self.filesystem_path}'",
      "export FSTYPE='ext4'",
      <<EOF
      if ! lsblk -o NAME,FSTYPE | grep $DEVICE | grep $FSTYPE; then
          mkfs.ext4 $DEVICE
      fi 
      EOF,
      "mkdir -p /mnt/${local.volume_name}",
      "mount ${self.filesystem_path} /mnt/${local.volume_name}"
    ]
  }
}
