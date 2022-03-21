#---------------------------- spoke 1 -------------------------------
output "spoke1_vm1" {
  value = {
    "dns_name"   = "${local.env_prefix}-spoke1-vm1.${azurerm_private_dns_zone.private_dns_zone.name}",
    "public_IP"  = module.spoke_1_vm1.public_ip.ip_address,
    "private_ip" = module.spoke_1_vm1.private_ip
  }
}

output "spoke1_vm2" {
  value = { 
     "dns_name"   = "${local.env_prefix}-spoke1-vm2.${azurerm_private_dns_zone.private_dns_zone.name}",
     "public_IP" = module.spoke_1_vm2.public_ip.ip_address, 
     "private_ip" = module.spoke_1_vm2.private_ip 
     }
}

output "spoke1_vm3" {
  value = { 
     "dns_name"   = "${local.env_prefix}-spoke1-vm3.${azurerm_private_dns_zone.private_dns_zone.name}",
     "public_IP" = module.spoke_1_vm3.public_ip.ip_address, 
     "private_ip" = module.spoke_1_vm3.private_ip 
     }
}

output "spoke1_vm4" {
  value = { 
     "dns_name"   = "${local.env_prefix}-spoke1-vm4.${azurerm_private_dns_zone.private_dns_zone.name}",
     "public_IP" = module.spoke_1_vm4.public_ip.ip_address, 
     "private_IP" = module.spoke_1_vm4.private_ip 
     }
}

output "spoke1_vm5" {
  value = { 
     "dns_name"   = "${local.env_prefix}-spoke1-vm5.${azurerm_private_dns_zone.private_dns_zone.name}",
     "public_IP" = module.spoke_1_vm5.public_ip.ip_address, 
     "private_IP" = module.spoke_1_vm5.private_ip 
     }
}

#---------------------------- spoke 2 -------------------------------
output "spoke2_vm1" {
  value = { 
     "dns_name"   = "${local.env_prefix}-spoke2-vm1.${azurerm_private_dns_zone.private_dns_zone.name}",
     "public_IP" = module.spoke_2_vm1.public_ip.ip_address, 
     "private_IP" = module.spoke_2_vm1.private_ip 
     }
}

output "spoke2_vm2" {
  value = { 
     "dns_name"   = "${local.env_prefix}-spoke2-vm2.${azurerm_private_dns_zone.private_dns_zone.name}",
  "public_IP" = module.spoke_2_vm2.public_ip.ip_address, 
  "private_IP" = module.spoke_2_vm2.private_ip 
  }
}

output "spoke2_vm3" {
  value = { 
     "dns_name"   = "${local.env_prefix}-spoke2-vm2.${azurerm_private_dns_zone.private_dns_zone.name}",
     "public_IP" = module.spoke_2_vm3.public_ip.ip_address, 
     "private_IP" = module.spoke_2_vm3.private_ip
      }
}

