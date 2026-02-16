output "public_subnet_id" {
    value = azurerm_subnet.medha_subnet_public.id
}

output "private_subnet_id" {
    value = azurerm_subnet.medha_subnet_private.id
}