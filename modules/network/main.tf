

/*  network_rules = {
    mysql = {port=3306, priority 100}
    redis = {port=6379, priority 101}
    mongodb = {port=27017, priority 102}
    rabbitmq = {port=5672, priority 103}

} */
resource "azurerm_network_security_group" "ec2_sg" {
  name                =   var.sg_name #"medha-security-group"
  location            = azurerm_resource_group.rg_name.location
  resource_group_name = azurerm_resource_group.rg_name.name
  dynamic security_rule {
    for_each = var.network_rules
    content{
    name                       = security_rule.key
    priority                   = security_rule.value.priority
    destination_port_range     = security_rule.value.port
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    }
 }
}

resource "azurerm_network_security_group" "private_subnet_nsg" {
  name                = var.private_subnet_nsg_name #"medha-security-group"
  location            = azurerm_resource_group.rg_name.location
  resource_group_name = azurerm_resource_group.rg_name.name

  security_rule {
    name                       = "allow-from-public-subnet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes     = var.public_subnet_address_prefixes
    destination_address_prefix = "*"
  }
}



resource "azurerm_virtual_network" "medha_network" {
  name                = var.network_name #"medha-network"
  location            = azurerm_resource_group.rg_name.location
  resource_group_name = azurerm_resource_group.rg_name.name
  address_space       = var.address_space 

}

resource "azurerm_subnet" "medha_subnet_public" {
  name                 = var.public_subnet_name #"example-subnet"
  resource_group_name  = azurerm_resource_group.rg_name.name
  virtual_network_name = azurerm_virtual_network.medha_network.name
  address_prefixes     = var.public_subnet_address_prefixes 
}

resource "azurerm_subnet" "medha_subnet_private" {
  name                 = var.private_subnet_name #"example-subnet"
  resource_group_name  = azurerm_resource_group.rg_name.name
  virtual_network_name = azurerm_virtual_network.medha_network.name
  address_prefixes     = var.private_subnet_address_prefixes

}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.medha_subnet_private.id
  network_security_group_id = azurerm_network_security_group.private_subnet_nsg.id
}
