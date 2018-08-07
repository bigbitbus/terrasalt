#   Copyright 2018 BigBitBus Inc. http://bigbitbus.com
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id = "${var.client_id}"
  tenant_id = "${var.tenant_id}"
  client_secret = "${var.client_secret}"
}

resource "azurerm_resource_group" "myterraformgroup" {
  name     = "myterraformgroup"
  location = "${var.region}"
}

# Create virtual network
resource "azurerm_virtual_network" "myterraformnetwork" {
  name                = "myVnet"
  address_space       = ["10.0.0.0/16"]
  location = "${var.region}"
  resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"
}

# Create subnet
resource "azurerm_subnet" "myterraformsubnet" {
  name                 = "mySubnet"
  resource_group_name  = "${azurerm_resource_group.myterraformgroup.name}"
  virtual_network_name = "${azurerm_virtual_network.myterraformnetwork.name}"
  address_prefix       = "10.0.1.0/24"
}



# Create Network Security Group and rule
resource "azurerm_network_security_group" "myterraformgroup" {
  name                = "myNetworkSecurityGroup"
  location = "${var.region}"
  resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}
# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = "${azurerm_resource_group.myterraformgroup.name}"
  }
  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = "${azurerm_resource_group.myterraformgroup.name}"
  location = "${var.region}"
  account_tier             = "Standard" #Or, could be Premium depending on what you want from storage.
  account_replication_type = "LRS"

}

module "azurevm1" {
  source = "./azure_module"
  instance_type = "${var.instance_type}"
  ssh_user = "${var.ssh_user}"
  key_data = "${var.key_data}"
  region = "${var.region}"
  resource_group_name= "${azurerm_resource_group.myterraformgroup.name}"
  security_group_id ="${azurerm_network_security_group.myterraformgroup.id}"
  subnet_id = "${azurerm_subnet.myterraformsubnet.id}"
}

# The dependence variable ensures that azurevm1 is completed before salt1 starts (implicit dependency detected by terraform)
module "salt1" {
  source = "../modules/tf_mod_salt"
  salt_master = "${var.salt_master}"
  minion_id = "${var.platformgrain}-${var.instance_type}"
  ssh_user = "${var.ssh_user}"
  key_path = "${var.key_path}"
  ip = "${module.azurevm1.ip}"
  dependence = "${module.azurevm1.machineid}"
  platformgrain = "${var.platformgrain}"
}
