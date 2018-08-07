
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

# Create public IPs

resource "azurerm_public_ip" "myterraformpublicip" {
  name                         = "myPublicIP-${var.instance_type}"
 location = "${var.region}"
  resource_group_name          = "${var.resource_group_name}"
  public_ip_address_allocation = "dynamic"
  domain_name_label            = "salttest" # parameterize this (?)
}

# Create network interface
resource "azurerm_network_interface" "myterraformnic" {
  name                      = "myNIC-${var.instance_type}"
 location = "${var.region}"
  resource_group_name       = "${var.resource_group_name}"
  network_security_group_id = "${var.security_group_id}"

  ip_configuration {
    name                          = "myNicConfiguration--${var.instance_type}"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.myterraformpublicip.id}"
  }

}

# Create virtual machine

resource "azurerm_virtual_machine" "_my_azure_vm" {
  name = "my-azure-vm"
  location = "${var.region}"
  resource_group_name = "${var.resource_group_name}"
  network_interface_ids = [
    "${azurerm_network_interface.myterraformnic.id}"]
  vm_size = "${var.instance_type}"

  storage_os_disk {
    name = "myOsDisk"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # You probably want to parameterize this via variables.
  storage_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "16.04.0-LTS"
    version = "latest"
  }

  os_profile {
    computer_name = "my-azure-vm"
    admin_username = "${var.ssh_user}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path = "/home/${var.ssh_user}/.ssh/authorized_keys"
      key_data = "${var.key_data}"
    }
  }
}

output "ip" {
  value = "${azurerm_public_ip.myterraformpublicip.fqdn}"
}

#We will use this to force an implicit dependency so salt module runs after machine completes
output "machineid" {
  value = "${azurerm_virtual_machine._my_azure_vm.id}"
}
