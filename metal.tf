# This part of the code will create all relevant Metal assets
# ┐
# ├ Transit VLANs
# ├ A-Side Token for Fabric VCs
# ├ Server in desired location
# └ attach created VLANs to the server's bond0 interface

# ──────────────────────────────────────────────────────────────────────────────────────────

data "template_file" "userdata" {
  template = file("${path.module}/userdata.tftpl")
  vars  = {
    PRIM_ADDRESS_METAL = var.ip_address.metal_prim
    SEC_ADDRESS_METAL  = var.ip_address.metal_sec
    PRIM_ADDRESS_APEX  = var.ip_address.apex_prim
    SEC_ADDRESS_APEX   = var.ip_address.apex_sec
    PRIM_VLAN_ID       = var.vlan_id.prim
    SEC_VLAN_ID        = var.vlan_id.sec
    SUBNETMASK         = var.subnetmask
    }
  }

# ──────────────────────────────────────────────────────────────────────────────────────────

# CREATE VLAN
resource "equinix_metal_vlan" "metal_vlan" {
  for_each      = var.vlan_id
  description   = "Metal Side VLANs"
  project_id    = var.metal.project_id
  vxlan         = each.value
  metro         = var.metal.metro
}

# ──────────────────────────────────────────────────────────────────────────────────────────

# GENERATE METAL TOKENs
resource "equinix_metal_connection" "metal_token_pa" {
  depends_on = [ equinix_metal_vlan.metal_vlan ]

  name                  = "aside-metal-token-${var.metal.metro}"
  project_id            = var.metal.project_id
  type                  = var.metal.service_token.tenancy
  redundancy            = var.metal.service_token.redundancy
  metro                 = var.metal.metro
  speed                 = "${var.bandwidth}Mbps"
  service_token_type    = var.metal.service_token.type
  vlans                 = local.vlans
}

# ──────────────────────────────────────────────────────────────────────────────────────────

# CREATE METAL HOST
resource "equinix_metal_device" "metal_apex" {
  depends_on       = [ data.template_file.userdata ]

  hostname         = "metal-host-${var.metal.metro}-01"
  plan             = var.metal.node.sku
  metro            = var.metal.metro
  operating_system = var.metal.node.os
  billing_cycle    = var.metal.node.term
  project_id       = var.metal.project_id
  ip_address {
    type = "private_ipv4"
    cidr = 30
  }
  user_data        = data.template_file.userdata.rendered
}

# ──────────────────────────────────────────────────────────────────────────────────────────

resource "equinix_metal_port" "metal_apex" {
  depends_on    = [ equinix_metal_vlan.metal_vlan, equinix_metal_device.metal_apex ]
  port_id       = local.bond0_id
  layer2        = false
  bonded        = true
  vlan_ids      = local.vlans
}

# ──────────────────────────────────────────────────────────────────────────────────────────
