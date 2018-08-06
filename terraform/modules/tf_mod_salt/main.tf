resource "null_resource" "install_configure_salt" {
  connection {
    user = "${var.ssh_user}"
    private_key = "${file(var.key_path)}"
    host = "${var.ip}"
  }

  provisioner "file" {
    source = "${path.module}/files/installsaltminion.sh"
    destination = "/tmp/installsaltminion.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/installsaltminion.sh",
      "sudo /tmp/installsaltminion.sh ${var.salt_master} ${var.minion_id} ${var.platformgrain}",
    ]
    on_failure = "continue"
  }

  provisioner "local-exec" {
    command = "python ${path.module}/files/httpsrequests.py  ${var.minion_id} key.accept"
  }

  provisioner "local-exec" {
    command = "python ${path.module}/files/httpsrequests.py  ${var.minion_id} key.delete"
    when = "destroy"
  }

  #Dummy command to force use of dependence variable
  provisioner "local-exec" {
    command = "echo ${var.dependence} > /dev/null"
  }
}

