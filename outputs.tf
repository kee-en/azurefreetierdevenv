output "subnet_id" {
  value = module.network.subnet_id
}

output "public_ip_id" {
  value = module.network.public_ip_id
}

output "network_interface_id" {
  value = module.network.network_interface_id
}

output "public_ip_address" {
  value = module.vm.public_ip_address
}
