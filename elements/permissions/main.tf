resource "null_resource" "permissions_provisioner" {
  connection {
    type     = "ssh"
    user     = "root"
    password = var.node_password
    host     = var.node_ip_address
  }
  provisioner "remote-exec" {
    inline = [
      "mkdir -p ${var.node_path}",
      "chown -R ${var.uid}:${var.uid} ${var.node_path}"
    ]
  }
}
