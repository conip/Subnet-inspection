# working !! ------------
locals {
  env_prefix = "lab"

  subnet_map1 = flatten([
    #for name, address_prefix in azurerm_virtual_network.vnet_spoke_1.subnet : name => address_prefix 
    for subnet_block in azurerm_virtual_network.vnet_spoke_2.subnet : [
      for key, value in subnet_block : value
      if key == "name"
    ]
  ])
  subnet_map2 = flatten([
    #for name, address_prefix in azurerm_virtual_network.vnet_spoke_1.subnet : name => address_prefix 
    for subnet_block in azurerm_virtual_network.vnet_spoke_2.subnet : [
      for key, value in subnet_block : value
      if key == "address_prefix"
    ]
  ])
  subnet_map = zipmap(local.subnet_map1, local.subnet_map2)


  #-----------------------


  # subnet_map_result2 = flatten([
  #   for subnet in azurerm_virtual_network.vnet_spoke_1.subnet : [
  #     for key1, value1 in subnet : {
  #       for key2, value2 in subnet : value1 => value2
  #       if key2 == "address_prefix"
  #     }
  #     if key1 == "name"
  #   ]
  # ])

  /*

  + subnet_output_2 = [
      + {
          + subnet-user-1 = "10.113.1.0/24"
        },
      + {
          + subnet-user-2 = "10.113.2.0/24"
        },
      + {
          + subnet-avx-spoke-gw = "192.168.1.0/29"
        },
    ]

  */



  #   subnet_map_result2 = flatten([
  #     for subnet in azurerm_virtual_network.vnet_spoke_1.subnet : [
  #       for key1, value1 in subnet : [
  #         for key2, value2 in subnet : "${value1} => ${value2}"
  #         if key2 == "address_prefix"
  #       ]
  #       if key1 == "name"
  #     ]
  #   ])

  # }
  /*
  + subnet_output_2 = [
      + "subnet-user-1 => 10.113.1.0/24",
      + "subnet-user-2 => 10.113.2.0/24",
      + "subnet-avx-spoke-gw => 192.168.1.0/29",
    ]
*/

  subnet_map_result2 = flatten([
    for subnet in azurerm_virtual_network.vnet_spoke_2.subnet : [
      for key1, value1 in subnet : [
        for key2, value2 in subnet : { "${value1}" = "${value2}" }
        if key2 == "address_prefix"
      ]
      if key1 == "name"

    ]
  ])
  spoke2_user_subnet_1 = [
    for block in azurerm_virtual_network.vnet_spoke_2.subnet[*] : block
    if block["name"] == "subnet-user-1"

  ]

  spoke2_user_subnet_2 = [
    for block in azurerm_virtual_network.vnet_spoke_2.subnet[*] : block
    if block["name"] == "subnet-user-2"

  ]

  spoke2_user_subnet_3 = [
    for block in azurerm_virtual_network.vnet_spoke_2.subnet[*] : block
    if block["name"] == "subnet-user-3"

  ]
  /*
> type(local.subnet_map_result2)
tuple([
    object({
        subnet-user-1: string,
    }),
    object({
        subnet-user-2: string,
    }),
    object({
        subnet-avx-spoke-gw: string,
    }),
])
*/
  # object_all = { subnet_dummy = "value_dummy"}

  # result3 = flatten([
  #   for x in local.subnet_map_result2: [ 
  #     merge(x, object_all)
  #   ]
  # ])

  #   finding = [
  #     for x in local.subnet_map_result2: lookup(x, "subnet-avx-spoke-gw", "none") 
  #  ]

  /*
  + finding         = [
      + "none",
      + "none",
      + "192.168.1.0/29",
    ]
*/

  vnet2_aviatrix_subnet = [
    for x in local.subnet_map_result2 : x["subnet-avx-spoke-gw"]
    if lookup(x, "subnet-avx-spoke-gw", "none") != "none"
  ]

}

