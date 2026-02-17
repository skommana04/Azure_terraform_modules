resource "azurerm_network_interface" "nic" {
    name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# This is the "glue" that connects your NSG to your Subnet


resource "azurerm_linux_virtual_machine" "medha-vm" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.rg_name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size               = "Premium_LRS"

  admin_username        = "azureuser"

  admin_ssh_key {
    username = "azureuser"
    public_key = file("/home/admin/Desktop/azureagent_key.pub")
  }

    os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

#   tags = {
#     environment = "var.env"
#   }
}