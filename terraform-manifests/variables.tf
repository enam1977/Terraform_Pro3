

variable "location" {
  default     = "East us"
  description = "Location where resources will be created"
}

variable "admin_user" {
  description = "User name to use as the admin account on the VMs that will be part of the VM scale set"
  default     = "azureuser"
}

variable "admin_password" {
  description = "Default password for admin account"
  default     = "Allah@123"
}


# Virtual Network, Subnets and Subnet NSG's

## Virtual Network
variable "vnet_name" {
  description = "Virtual Network name"
  type        = string
  default     = "vnet-default"
}
variable "vnet_address_space" {
  description = "Virtual Network address_space"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}


# Web Subnet Name
variable "web_subnet_name" {
  description = "Virtual Network Web Subnet Name"
  type        = string
  default     = "websubnet"
}
# Web Subnet Address Space
variable "web_subnet_address" {
  description = "Virtual Network Web Subnet Address Spaces"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

#web linux inbound NAT port for all VMs
variable "lb_inbound_nat_ports" {
  description = "Web LB Inbound NAT Ports List"
  type        = list(string)
  default     = ["1022", "2022"]
}
# Linux VM Input Variables Placeholder file.
variable "web_linuxvm_size" {
  description = "Web Linux VM Size"
  type        = string
  default     = "Standard_DS1_v2"
}

variable "web_linuxvm_admin_user" {
  description = "Web Linux VM Admin Username"
  type        = string
  default     = "azureuser"
}

variable "application_type" {}
variable "resource_type" {}
//removed
