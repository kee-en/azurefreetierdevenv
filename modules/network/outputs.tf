output "subnet_id" {
  value = azurerm_subnet.subnet.id
}

output "public_ip_id" {
  value = azurerm_public_ip.public_ip.id
}

output "network_interface_id" {
  value = azurerm_network_interface.nic.id
}