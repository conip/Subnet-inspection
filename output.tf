output "TrGW_map" {
    value = tomap({
        "${module.AZ_transit_1_fw.transit_gateway.vpc_reg}" = "${module.AZ_transit_1_fw.transit_gateway.gw_name}",
        EU-Wes = "test"
    })
}

output "subnet_output_1" {
  value = local.subnet_map
}

# output "subnet_output_2" {
#   value = local.subnet_map_result2
# }
output "vnet2_aviatrix_subnet" {
  value = local.vnet2_aviatrix_subnet
}

# output "subnet_output_3" {
#   value = merge(local.result3)
# }

# output "subnet_output1" {
#   value = local.subnet_map1
# }

# output "subnet_output2" {
#   value = local.subnet_map2
# }


# output "spoke_vpc" {
#     value = module.az_spoke_1.vpc
# }

output "spoke1_vm1_public_IP" {
    value = module.spoke_1_vm1.public_ip.ip_address
}

output "spoke1_vm1_private_IP" {
    value = module.spoke_1_vm1.private_ip
}

output "spoke1_vm2_private_IP" {
    value = module.spoke_1_vm2.private_ip
}

output "spoke1_vm3_private_IP" {
    value = module.spoke_1_vm3.private_ip
}

output "spoke2_vm1_private_IP" {
 value = module.spoke_2_vm1.private_ip
}