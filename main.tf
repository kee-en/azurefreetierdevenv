provider "azurerm" {
  features {}
  subscription_id = "1e65ba5d-ab67-48bc-9e82-cc2279934dca"
}

module "network" {
  source              = "./modules/network"
  location            = var.location
  resource_group_name = var.resource_group_name
}

module "vm" {
  source               = "./modules/vm"
  location             = var.location
  resource_group_name  = var.resource_group_name
  subnet_id            = module.network.subnet_id
  public_ip_id         = module.network.public_ip_id
  network_interface_id = module.network.network_interface_id
}
