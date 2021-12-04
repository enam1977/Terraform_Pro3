
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
  }
  # Terraform State Storage to Azure Storage Container (Values will be taken from Azure DevOps)
  backend "azurerm" {
    tenant_id            = "dd152091-7e9a-448e-b6a0-223f687a2d84"
    resource_group_name  = "terraform-storage-rg"
    storage_account_name = "udacitystorage"
    container_name       = "tfstatefiles"
    key                  = "terraform.tfstate"
    access_key="dtGqN18sYg0y+2MoJE91LubVKQtxbCI/E7X/fkcNdWz/ftKR/eGu6xtMlvEJTtszlWeuAQN/zXmbqRVCnuiggw=="

  }
}


# Provider Block of azure
provider "azurerm" {

  subscription_id = "50d65e48-cd36-43c6-b861-3b1bcc7804e9"
client_id       = "69b5fb88-01a2-4b04-9827-d1f355334206"
client_secret   = "V.AaEP~heaKq9bZflCqkVQBu4J2-4Pw.3h"
tenant_id       = "dd152091-7e9a-448e-b6a0-223f687a2d84"

  features {}
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


variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
