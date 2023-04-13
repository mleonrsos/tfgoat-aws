#Temp VM and resources for testing
resource "azurerm_public_ip" "vm" {
  name                = "els-proxy-vm-public-ip"
  location            = "Canada Central"
  resource_group_name = data.azurerm_resource_group.networking.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "els_proxy_vm_nic" {
  name                = "els-proxy-prod-vm-nic"
  location            = "Canada Central"
  resource_group_name = data.azurerm_resource_group.networking.name

  ip_configuration {
    name                          = "els-proxy-prod-vm-ipconfig"
    subnet_id                     = data.azurerm_subnet.aks_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm.id
  }
}

resource "azurerm_virtual_machine" "els-proxy-net-test" {
  name                          = "els-proxy-vm"
  location                      = "Canada Central"
  resource_group_name           = data.azurerm_resource_group.networking.name
  network_interface_ids         = [azurerm_network_interface.els_proxy_vm_nic.id]
  vm_size                       = "Standard_B2s"
  delete_os_disk_on_termination = true

  storage_os_disk {
    name              = "els-proxy-vm-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "els-proxy-vm"
    admin_username = "azure-user"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/azure-user/.ssh/authorized_keys"
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDb7mBXfdH3O2PqwZqSD4LqOfhytxpVJzIEpZ75ebgFs50/BROND+3sUerBiPdbTIFLZ2XHilU+Zhqg6o8A4M5n2xZgjF572PyUISqRe7q3HeBIbeT0s61BqF5hMLuIfoBiPA2SQLxswICBW4eTzgJ+1Ud//M5Wsge7BGJ7lgkaMtoMGqwIzKCJRsznhK4lyvmdJ+UbAYltJxFUjz0WJPHnI0srDpaIZN6JOZQ0Qyl+aDWluQ1uep0TkluKyzzERR+kxKB2qlwIUaeH6xfSvESKU4ReSBd9vrog+VA3j1rKAZ144T/tLTgm/5C22whuCFjNG3HJPcyqjziFu3VW8GyDtTpxUmh/XuCxEijG0TUcfbzc+fTtx/mVTDir4rWslgHW3Dlhum/Uamw+H/I3K4ejzIrrVti5VVlsPnNGYZp6SMe75Y++0WIo9Z02GQtnGdIdbiuQZ2TnHXPl1DVecQ1Ax2rAUm0PgvLFJim9uBWi5N4bKUkc2oeW4sPwzN9mslJ+euCyO/7nLMaSK+Jfl3/7untIophkAkEvjUxOA+y1pvnp2fhiS9ExRrRLq0LfXi3CU7Z2Mn/LveBkku8SiAjRj0dxEOY+bJEVzcGn1wcoCrmGrtY6nlCwjwf/yqTc24IdS/Ijbc7LshlL3KLej+Rm6XjEWweT1F/nC4JxBf1cUQ== azure-user@els-proxy-vm"
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = data.azurerm_subnet.aks_subnet.id
  network_security_group_id = azurerm_network_security_group.ssh_allowed.id
}

resource "azurerm_network_security_group" "ssh_allowed" {
  name                = "ssh-allowed-nsg"
  location            = "Canada Central"
  resource_group_name = data.azurerm_resource_group.networking.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "173.171.77.244" # Set this to your IP address
    destination_address_prefix = "*"
  }
}
