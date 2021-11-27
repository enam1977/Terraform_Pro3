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
