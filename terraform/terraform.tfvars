business_divsion        = "ATT"
environment             = "dev"
resource_group_name     = "terraform-storage-rg"
resource_group_location = "East US"
vnet_name               = "vnet"
vnet_address_space      = ["10.1.0.0/16"]

web_subnet_name    = "websubnet"
web_subnet_address = ["10.1.1.0/24"]

lb_inbound_nat_ports = ["1022", "2022"]
application_type     = "webapp"
resource_type        = "webappservice"







