# Random String Resource
resource "random_string" "myrandom" {
  length  = 6
  upper   = false
  special = false
  number  = false
}
#pull up resource group data from portal
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name

}
# Resource-1: Create Public IP Address for Azure Load Balancer
resource "azurerm_public_ip" "web_publicip" {
  name                = "${local.resource_name_prefix}-publicip"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.resource_group_location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.common_tags
}

# Create Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "${local.resource_name_prefix}-${var.vnet_name}"
  address_space       = var.vnet_address_space
  location            = var.resource_group_location
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = local.common_tags
}

#create Network interface
resource "azurerm_network_interface" "web_linuxvm_nic" {
  //count               = var.web_linuxvm_instance_count
  name                = "${local.resource_name_prefix}-web-linuxvm-nic"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.resource_group_location

  ip_configuration {
    name                          = "web-linuxvm-ip-1"
    subnet_id                     = azurerm_subnet.websubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web_publicip.id
  }
}

# Locals Block for custom data
locals {
  webvm_custom_data = <<CUSTOM_DATA
#!/bin/sh
#!/bin/sh
#sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd  
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo chmod -R 777 /var/www/html 
sudo echo "Welcome to stacksimplify - WebVM App1 - VM Hostname: $(hostname)" > /var/www/html/index.html
sudo mkdir /var/www/html/app1
sudo echo "Welcome to stacksimplify - WebVM App1 - VM Hostname: $(hostname)" > /var/www/html/app1/hostname.html
sudo echo "Welcome to stacksimplify - WebVM App1 - App Status Page" > /var/www/html/app1/status.html
sudo echo '<!DOCTYPE html> <html> <body style="background-color:rgb(250, 210, 210);"> <h1>Welcome to Stack Simplify - WebVM APP-1 </h1> <p>Terraform Demo</p> <p>Application Version: V1</p> </body></html>' | sudo tee /var/www/html/app1/index.html
sudo curl -H "Metadata:true" --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2020-09-01" -o /var/www/html/app1/metadata.html
CUSTOM_DATA  
}

# # Resource: Azure Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "web_linuxvm" {
  //count = var.web_linuxvm_instance_count
  name = "${local.resource_name_prefix}-web-linuxvm"
  #computer_name = "web-linux-vm"  # Hostname of the VM (Optional)
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.resource_group_location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  //network_interface_ids = [azurerm_network_interface.web_linuxvm_nic.id]
  network_interface_ids = [azurerm_network_interface.web_linuxvm_nic.id]
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }

  #custom_data = filebase64("${path.module}/app-scripts/redhat-webvm-script.sh")    
  custom_data = base64encode(local.webvm_custom_data)

}

# Resource-1: Create WebTier Subnet
resource "azurerm_subnet" "websubnet" {
  name                 = "${azurerm_virtual_network.vnet.name}-${var.web_subnet_name}"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.web_subnet_address
}

# Resource-2: Create Network Security Group (NSG)
resource "azurerm_network_security_group" "web_subnet_nsg" {
  name                = "${azurerm_subnet.websubnet.name}-nsg"
  location            = var.resource_group_location
  resource_group_name = data.azurerm_resource_group.rg.name
}

# Resource-3: Associate NSG and Subnet
resource "azurerm_subnet_network_security_group_association" "web_subnet_nsg_associate" {
  depends_on                = [azurerm_network_security_rule.web_nsg_rule_inbound_22] # Every NSG Rule Association will disassociate NSG from Subnet and Associate it, so we associate it only after NSG is completely created - Azure Provider Bug https://github.com/terraform-providers/terraform-provider-azurerm/issues/354  
  subnet_id                 = azurerm_subnet.websubnet.id
  network_security_group_id = azurerm_network_security_group.web_subnet_nsg.id
}

# Resource-4: Create NSG Rules
## Locals Block for Security Rules

## NSG Inbound Rule for WebTier Subnets
resource "azurerm_network_security_rule" "web_nsg_rule_inbound_22" {
  //for_each                    = local.web_inbound_ports_map
  name                        = "Rule-Port-22"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.web_subnet_nsg.name
}
resource "azurerm_network_security_rule" "web_nsg_rule_inbound_80" {
  //for_each                    = local.web_inbound_ports_map
  name                        = "Rule-Port-80"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "Tcp"
  source_port_range           = "80"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.web_subnet_nsg.name
}





/*
# Resource-2: Create Azure Standard Load Balancer
resource "azurerm_lb" "web_lb" {
  name                = "${local.resource_name_prefix}-web-lb"
  location            = var.resource_group_location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "web-lb-publicip-1"
    public_ip_address_id = azurerm_public_ip.web_publicip.id
  }
}
# Resource-3: Create LB Backend Pool
resource "azurerm_lb_backend_address_pool" "web_lb_backend_address_pool" {
  name            = "web-backend"
  loadbalancer_id = azurerm_lb.web_lb.id
}
# Resource-4: Create LB Probe
resource "azurerm_lb_probe" "web_lb_probe" {
  name                = "tcp-probe"
  protocol            = "Tcp"
  port                = 80
  loadbalancer_id     = azurerm_lb.web_lb.id
  resource_group_name = data.azurerm_resource_group.rg.name
}
# Resource-5: Create LB Rule
resource "azurerm_lb_rule" "web_lb_rule_app1" {
  name                           = "web-app1-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.web_lb.frontend_ip_configuration[0].name
  backend_address_pool_id        = azurerm_lb_backend_address_pool.web_lb_backend_address_pool.id
  probe_id                       = azurerm_lb_probe.web_lb_probe.id
  loadbalancer_id                = azurerm_lb.web_lb.id
  resource_group_name            = data.azurerm_resource_group.rg.name
}
# Resource-6: Associate Network Interface and Standard Load Balancer
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association
resource "azurerm_network_interface_backend_address_pool_association" "web_nic_lb_associate" {
  //for_each                = var.web_linuxvm_instance_count
  //count                   = var.web_linuxvm_instance_count
  network_interface_id    = azurerm_network_interface.web_linuxvm_nic.id
  ip_configuration_name   = azurerm_network_interface.web_linuxvm_nic.ip_configuration.name
  backend_address_pool_id = azurerm_lb_backend_address_pool.web_lb_backend_address_pool.id
}
# Azure LB Inbound NAT Rule
resource "azurerm_lb_nat_rule" "web_lb_inbound_nat_rule_22" {
  depends_on = [azurerm_linux_virtual_machine.web_linuxvm] # To effectively handle azurerm provider related dependency bugs during the destroy resources time
  //for_each = var.web_linuxvm_instance_count
  //count = var.web_linuxvm_instance_count
  name = "vm-ssh-${var.lb_inbound_nat_ports}-vm22"
  #name = "${each.key}-ssh-${each.value}-vm-22"
  protocol      = "Tcp"
  frontend_port = var.lb_inbound_nat_ports
  #frontend_port = each.value,
  #frontend_port = lookup(var.web_linuxvm_instance_count, each.key)
  backend_port                   = 22
  frontend_ip_configuration_name = azurerm_lb.web_lb.frontend_ip_configuration[0].name
  resource_group_name            = data.azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.web_lb.id
}
# Associate LB NAT Rule and VM Network Interface
resource "azurerm_network_interface_nat_rule_association" "web_nic_nat_rule_associate" {
  #for_each              = var.web_linuxvm_instance_count
  //count                 = var.web_linuxvm_instance_count
  network_interface_id  = azurerm_network_interface.web_linuxvm_nic.id
  ip_configuration_name = azurerm_network_interface.web_linuxvm_nic.ip_configuration.name
  nat_rule_id           = azurerm_lb_nat_rule.web_lb_inbound_nat_rule_22.id
}
*/

//https://docs.microsoft.com/en-us/azure/developer/terraform/create-vm-cluster-with-infrastructure
//create add servicegit  
resource "azurerm_app_service_plan" "test" {
  name                = "${var.application_type}-${var.resource_type}-test"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_app_service" "test" {
  name                = "${var.application_type}-${var.resource_type}-test"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.test.id

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = 0
  }
}
