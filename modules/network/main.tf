
resource "azurerm_network_security_group" "sg" {
  name                =   var.sg_name #"medha-security-group"
  location            = azurerm_resource_group.rg_name.location
  resource_group_name = azurerm_resource_group.rg_name.name
}

resource "azurerm_virtual_network" "medha_network" {
  name                = var.network_name #"medha-network"
  location            = azurerm_resource_group.rg_name.location
  resource_group_name = azurerm_resource_group.rg_name.name
  address_space       = var.address_space 

}

resource "azurerm_subnet" "medha_subnet" {
  name                 = var.subnet_name #"example-subnet"
  resource_group_name  = azurerm_resource_group.rg_name.name
  virtual_network_name = azurerm_virtual_network.medha_network.name
  address_prefixes     = var.address_prefixes 
}