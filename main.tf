resource "azurerm_resource_group" "blog" {
  name     = "blog"
  location = var.resource_group_location
}
resource "azurerm_virtual_network" "terraform_test_network" {
  name                = "terraform-vnet"
  address_space       = ["192.168.0.0/16"]
  location            = azurerm_resource_group.blog.location
  resource_group_name = azurerm_resource_group.blog.name
}
resource "azurerm_subnet" "terraform_test_subnet" {
  name                 = "terraform-subnet"
  address_prefixes     = ["192.168.0.0/24"]
  virtual_network_name = azurerm_virtual_network.terraform_test_network.name
  resource_group_name  = azurerm_resource_group.blog.name
}

resource "azurerm_network_interface" "terraform_test_nic" {
  name                = "terraform-nic"
  location            = azurerm_resource_group.blog.location
  resource_group_name = azurerm_resource_group.blog.name

  ip_configuration {
    name                          = "test_nic_config"
    subnet_id                     = azurerm_subnet.terraform_test_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "192.168.0.10"
  }
}

resource "azurerm_linux_virtual_machine" "terraform_test_VM" {
  name                  = "DB-postgreSQL"
  location              = azurerm_resource_group.blog.location
  resource_group_name   = azurerm_resource_group.blog.name
  network_interface_ids = [azurerm_network_interface.terraform_test_nic.id]
  size                  = "Standard_A1"
  admin_username        = "testadmin"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_ssh_key {
    username   = "testadmin"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
} 

resource "azurerm_network_interface" "express_nic" {
  name                = "Express-NIC"
  location            = azurerm_resource_group.blog.location
  resource_group_name = azurerm_resource_group.blog.name

  ip_configuration {
    name                          = "express-ipconfig"
    subnet_id                     = azurerm_subnet.terraform_test_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "192.168.0.11"
  }
}

resource "azurerm_linux_virtual_machine" "Express-VM" {
  name                  = "BE-Express"
  location              = azurerm_resource_group.blog.location
  resource_group_name   = azurerm_resource_group.blog.name
  network_interface_ids = [azurerm_network_interface.express_nic.id]
  size                  = "Standard_A1"
  admin_username        = "testadmin"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_ssh_key {
    username   = "testadmin"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
} 