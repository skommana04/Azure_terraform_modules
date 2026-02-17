# Inside your VM module's outputs.tf
output "public_ip" {
  value = azurerm_linux_virtual_machine.medha_vm.public_ip_address
}

/* output "vm_name" {
  value = azurerm_linux_virtual_machine.medha_vm[*].name
} */