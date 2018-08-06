provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

module "awsvm1" {
  source = "./aws_module"
  ami = "${lookup(var.ami, var.region)}"
  instance_type = "${var.instance_type}"
  ssh_key_name = "${var.ssh_key_name}"
  region = "${var.region}"
}


# The dependence also ensures that awsvm1 is completed before salt1 starts (implicit dependency detected by terraform)
module "salt1" {
  source = "../modules/tf_mod_salt"
  salt_master = "${var.salt_master}"
  minion_id = "${var.platformgrain}-${var.instance_type}"
  ssh_user = "${var.ssh_user}"
  key_path = "${var.key_path}"
  ip = "${module.awsvm1.ip}"
  dependence = "${module.awsvm1.ip}"
  platformgrain = "${var.platformgrain}"
}
