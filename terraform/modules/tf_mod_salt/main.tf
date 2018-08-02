resource "null_resource" "install_configure_salt" {
  connection {
    user = "${var.ssh_user}"
    private_key = "${file(var.key_path)}"
    host = "${var.public_ip}"
  }

  provisioner "file" {
    source = "${path.module}/files/installsaltminion.sh"
    destination = "/tmp/installsaltminion.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/installsaltminion.sh",
      "sudo /tmp/installsaltminion.sh ${ var.salt_master} ${var.minion_id} ${var.platformgrain}",
    ]
    on_failure = "continue"
  }

  provisioner "local-exec" {
    command = "docker exec -i  ${var.docker_minion} salt-call  event.fire_master \"{'acceptedminion':'${var.minion_id}'}\" salt/minion/accept"
  }

  provisioner "local-exec" {
    command = "docker exec -i  ${var.docker_minion} salt-call  event.fire_master \"{'deletedminion':'${var.minion_id}'}\" salt/minion/delete"
    when = "destroy"
  }
}

