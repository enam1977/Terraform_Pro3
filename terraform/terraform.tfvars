business_divsion        = "ATT"
environment             = "dev"
resource_group_name     = "terraform-storage-rg"
resource_group_location = "East US"
vnet_name               = "vnet"
vnet_address_space      = ["10.1.0.0/16"]

web_subnet_name    = "websubnet"
web_subnet_address = ["10.1.1.0/24"]
//server_name                = "packer"
//packer_image_name          = "Udemy_PackerImage"
//web_linuxvm_instance_count = 1
lb_inbound_nat_ports = ["1022", "2022"]
application_type     = "webapp"
resource_type        = "webappservice"
admin_username       = "azureuser"
# Azure subscription vars
//subscription_id = "50d65e48-cd36-43c6-b861-3b1bcc7804e9"
//client_id       = "21331ae3-df85-4cc9-be3e-445508caa15c"
//client_secret   = "b1Mlrps_T34tDmfb7NaNB_J4Jd.LTFBnmS"
//tenant_id       = "dd152091-7e9a-448e-b6a0-223f687a2d84"





