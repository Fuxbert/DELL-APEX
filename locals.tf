# CREATE LOCAL VARIABLES FOR FURTHER USE IN RESOURCES
# Based on the assumption that server networking is set to hybrid bonded!

# ---------------------------------------------------------------------------------------------------

locals {
  vlans = [for i in var.vlan_id : i ]
  bond0_id = [ for p in equinix_metal_device.metal_apex.ports: p.id if p.name == "bond0" ][ 0 ]
  tokens = [ for i in var.apex_zside_token : i ]
  redundancy = [ "prim", "sec" ]
  }
