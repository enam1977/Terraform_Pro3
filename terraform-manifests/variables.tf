# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0"
    }
  }
  # Terraform State Storage to Azure Storage Container (Values will be taken from Azure DevOps)
  backend "azurerm" {
    //client_id            = "cb90761c-f02e-4474-91c5-1012308206c8"
    //client_secret        = "d3b9da20-5cab-4267-9621-35f9875e36ad"
    //subscription_id      = "50d65e48-cd36-43c6-b861-3b1bcc7804e9"
    //tenant_id            = "dd152091-7e9a-448e-b6a0-223f687a2d84"
    //resource_group_name  = "terraform-storage-rg"
    //container_name       = "tfstatefiles"
    //key                  = "terraform-manifest-terraform.tfstate"
    //storage_account_name = "enamstorage"
    //access_key           = "p1MVHl2TaO3MVbDam8XMoBhY6WinAenYnAAN3uv85jM4/P2lDfQ1Q1PLRXL2YZXrKraZhqpH9mcdryqxUn1pag=="
  }
}

# Provider Block
provider "azurerm" {
  tenant_id = "dd152091-7e9a-448e-b6a0-223f687a2d84"

  #client_id: "698c36ba-5f91-4d2c-9993-76a5da21eb06",
  #client_secret: "NyySxNK1.-cBcGZTtcCp9vHwv6D4mUyapO",
  features {}
}
# simple e aded to chek

# Generic Input Variables
# Business Division
variable "business_divsion" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type        = string
  default     = "radio"
}
# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = "uda"
}

variable "packer_resource_group_name" {
  description = "Name of the resource group in which the Packer image will be created"
  default     = "Udacity_rg"
}
variable "resource_group_name" {
  description = "name of the resource group name"
  //type        = string
  default = "terraform-storage-rg"
}
# Azure Resources Location
variable "resource_group_location" {
  description = "Region in which Azure Resources to be created"
  //type        = string
  default = "East US"
}
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


# Define Local Values in Terraform
locals {
  owners               = var.business_divsion
  environment          = var.environment
  resource_name_prefix = "${var.business_divsion}-${var.environment}"
  #name = "${local.owners}-${local.environment}"
  common_tags = {
    owners      = local.owners
    environment = local.environment
  }
}

variable "server_name" {
  description = "name of the server"
  default     = "packer"
}

# Packer image variable declare
variable "packer_image_name" {
  description = "Name of the created packer image"
  type        = string
  default     = "Udemy_PackerImage"

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

#weblinux Vm instance count
variable "web_linuxvm_instance_count" {
  description = "total instance count "
  type        = number
  default     = 1
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



