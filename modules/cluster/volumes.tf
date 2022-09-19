resource "linode_volume" "main_node_volume" {
  label     = "${var.cluster_name}-main"
  region    = var.linode_region
  size      = 50
  linode_id = data.linode_instances.main_nodes.instances.0.id
  depends_on = [
    time_sleep.cluster_ready
  ]
}

resource "null_resource" "mount_main_node_volume" {

  triggers = {
    main_node_instance_id  = data.linode_instances.main_nodes.instances.0.id
    cluster_data_volume_id = linode_volume.main_node_volume.id
  }

  depends_on = [
    linode_volume.main_node_volume,
    time_sleep.cluster_ready
  ]

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = var.root_password
      host     = data.linode_instances.main_nodes.instances.0.ip_address
    }
    inline = [
      "export DEVICE='${linode_volume.main_node_volume.filesystem_path}'",
      "export MOUNTPOINT=/mnt/${linode_volume.main_node_volume.label}",
      "export FSTYPE='ext4'",
      "blkid --match-token TYPE=$FSTYPE $DEVICE || mkfs.ext4 $DEVICE",
      "mkdir -p $MOUNTPOINT",
      "mount $DEVICE $MOUNTPOINT",
      "echo \"$DEVICE $MOUNTPOINT ext4 defaults,noatime,nofail 0 2\" >> /etc/fstab"
    ]
  }

}
