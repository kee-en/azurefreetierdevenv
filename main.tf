provider "azurerm" {
  features {}
  subscription_id = "1e65ba5d-ab67-48bc-9e82-cc2279934dca"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_name}-rg"
  location = var.location
}

module "network" {
  source              = "./modules/network"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  resource_name       = var.resource_name
}

module "vm" {
  source               = "./modules/vm"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  resource_name        = var.resource_name
  subnet_id            = module.network.subnet_id
  public_ip_id         = module.network.public_ip_id
  network_interface_id = module.network.network_interface_id
  availability_set_id = module.network.availability_set_id
}
