
resource "aws_instance" "_aws_vm" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.ssh_key_name}"
}

output "ip" {
  value = "${aws_instance._aws_vm.public_ip}"
}