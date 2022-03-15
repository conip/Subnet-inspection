#---------------------------------------------------------- Transit ----------------------------------------------------------
module "AZ_transit_1_fw" {
  source  = "terraform-aviatrix-modules/azure-transit-firenet/aviatrix"
  version = "5.0.1"

  name                     = "AZ-trans-1"
  region                   = "UK South"
  cidr                     = "10.111.0.0/23"
  account                  = var.avx_ctrl_account_azure
  ha_gw                    = false
  firewall_image           = "Palo Alto Networks VM-Series Flex Next-Generation Firewall Bundle 1"
  firewall_image_version   = "10.1.4"
  firewall_username        = var.palo_username
  password                 = var.palo_password
  bootstrap_storage_name_1 = var.palo_bootstrap_storage_name_1
  storage_access_key_1     = var.azure_storage_access_key_1
  file_share_folder_1      = var.palo_file_share_folder_1
  local_as_number          = "65101"
  tags = {
    Owner = "pkonitz"
  }
}


#--------------------------------------------------------- SPOKE 1 --------------------------------------------------------
module "az_spoke_1" {
  source     = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version    = "1.1.0"
  name       = "AZ-spoke-1"
  cloud      = "Azure"
  region     = "UK South"
  cidr       = "10.112.0.0/16"
  transit_gw = module.AZ_transit_1_fw.transit_gateway.gw_name
  account    = var.avx_ctrl_account_azure
  depends_on = [
    module.AZ_transit_1_fw
  ]
}

module "spoke_1_vm1" {
  source    = "git::https://github.com/conip/terraform-azure-instance-build-module.git"
  name      = "spoke1-vm1-jump"
  region    = "UK South"
  rg        = module.az_spoke_1.vpc.resource_group
  subnet_id = module.az_spoke_1.vpc.public_subnets[1].subnet_id
  ssh_key   = var.ssh_key
  public_ip = true
  depends_on = [
    module.az_spoke_1
  ]
}

module "spoke_1_vm2" {
  source    = "git::https://github.com/conip/terraform-azure-instance-build-module.git"
  name      = "spoke1-vm2"
  region    = "UK South"
  rg        = module.az_spoke_1.vpc.resource_group
  subnet_id = module.az_spoke_1.vpc.private_subnets[1].subnet_id
  ssh_key   = var.ssh_key
  public_ip = false
  depends_on = [
    module.az_spoke_1
  ]
}

module "spoke_1_vm3" {
  source    = "git::https://github.com/conip/terraform-azure-instance-build-module.git"
  name      = "spoke1-vm3"
  region    = "UK South"
  rg        = module.az_spoke_1.vpc.resource_group
  subnet_id = module.az_spoke_1.vpc.public_subnets[1].subnet_id
  ssh_key   = var.ssh_key
  public_ip = true
  depends_on = [
    module.az_spoke_1
  ]
}

resource "aviatrix_spoke_gateway_subnet_group" "subnet_group_spoke1_prod" {
  name    = "spoke1-sub-prod"
  gw_name = module.az_spoke_1.spoke_gateway.gw_name
  subnets = ["${module.az_spoke_1.vpc.private_subnets[1].cidr}~~${module.az_spoke_1.vpc.private_subnets[1].name}"]
  depends_on = [
    module.az_spoke_1
  ]
}

resource "aviatrix_spoke_gateway_subnet_group" "subnet_group_spoke1_open" {
  name    = "spoke1-sub-open"
  gw_name = module.az_spoke_1.spoke_gateway.gw_name
  subnets = ["${module.az_spoke_1.vpc.public_subnets[1].cidr}~~${module.az_spoke_1.vpc.public_subnets[1].name}"]
  depends_on = [
    module.az_spoke_1
  ]
}


resource "aviatrix_transit_firenet_policy" "inspection_spoke1_prod" {
  transit_firenet_gateway_name = module.AZ_transit_1_fw.transit_gateway.gw_name
  inspected_resource_name      = "SPOKE_SUBNET_GROUP:${module.az_spoke_1.spoke_gateway.gw_name}~~${aviatrix_spoke_gateway_subnet_group.subnet_group_spoke1_prod.name}"
  depends_on = [
    module.az_spoke_1,
    module.AZ_transit_1_fw
  ]
}

resource "aviatrix_transit_firenet_policy" "inspection_spoke1_open" {
  transit_firenet_gateway_name = module.AZ_transit_1_fw.transit_gateway.gw_name
  inspected_resource_name      = "SPOKE_SUBNET_GROUP:${module.az_spoke_1.spoke_gateway.gw_name}~~${aviatrix_spoke_gateway_subnet_group.subnet_group_spoke1_open.name}"
  depends_on = [
    module.az_spoke_1,
    module.AZ_transit_1_fw
  ]
}



#-------------------------------------------------- SPOKE 2 --------------------------------------------------------



resource "azurerm_resource_group" "rg-test" {
  name     = "RG-spoke-2CIDRs"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet_spoke_2" {
  name                = "example-network"
  location            = azurerm_resource_group.rg-test.location
  resource_group_name = azurerm_resource_group.rg-test.name
  address_space       = ["10.113.0.0/16", "192.168.1.0/29"]

  subnet {
    name           = "subnet-user-1"
    address_prefix = "10.113.1.0/24"
  }
  subnet {
    name           = "subnet-user-2"
    address_prefix = "10.113.2.0/24"
  }

  subnet {
    name           = "subnet-avx-spoke-gw"
    address_prefix = "192.168.1.0/29"
  }
}

module "az_spoke_2" {
  source           = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version          = "1.1.0"
  name             = "AZ-spoke-2"
  cloud            = "Azure"
  region           = "West Europe"
  use_existing_vpc = true
  vpc_id           = "${azurerm_virtual_network.vnet_spoke_2.name}:${azurerm_resource_group.rg-test.name}"
  gw_subnet        = local.vnet2_aviatrix_subnet[0]
  hagw_subnet      = local.vnet2_aviatrix_subnet[0]
  transit_gw       = module.AZ_transit_1_fw.transit_gateway.gw_name
  account          = var.avx_ctrl_account_azure
  depends_on = [
    azurerm_virtual_network.vnet_spoke_2
  ]
}

module "spoke_2_vm1" {
  source    = "git::https://github.com/conip/terraform-azure-instance-build-module.git"
  name      = "spoke2-vm2-jump"
  region    = "West Europe"
  rg        = azurerm_resource_group.rg-test.name
  subnet_id = local.spoke2_user_subnet_id_1[0]
  ssh_key   = var.ssh_key
  public_ip = true
}



