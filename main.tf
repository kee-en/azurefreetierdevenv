provider "azurerm" {
  features {}
  subscription_id = "1e65ba5d-ab67-48bc-9e82-cc2279934dca"
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "dev-env-rg"
  location = "Southeast Asia"
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "dev-env-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "dev-env-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "public_ip" {
  name = "dev-env-public-ip"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  allocation_method = "Dynamic"
}

# Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "dev-env-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}

# Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "dev-env-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  admin_username      = "devuser"
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  admin_ssh_key {
    username   = "devuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

# Output
output "public_ip" {
  value = azurerm_linux_virtual_machine.vm.network_interface_ids[0]
}
