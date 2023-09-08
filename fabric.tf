# This part of the code will create the Fabric Virtual Connection
# from the Metal Shared Ports to DELL-APEX Fabric Ports via Service Tokens.
#
# Dependencies:
# ┐
# ├ Metal Interconnection Token
# └ Metal VLAN

# ──────────────────────────────────────────────────────────────────────────────────────────
# CREATE VC

resource "equinix_fabric_connection" "metal-apex-vc-redundant" {
  depends_on    = [equinix_metal_connection.metal_token_pa]

  count         = length(local.redundancy)
  name          = "metal-apex-${lower(var.metro)}-${element(local.redundancy, count.index)}"
  bandwidth     = var.bandwidth
  type          = "EVPL_VC"
  a_side {
    service_token {
      type = "VC_TOKEN"
      uuid = equinix_metal_connection.metal_token_pa.service_tokens[count.index].id
    }
  }
  z_side {
    service_token {
      type      = "VC_TOKEN"
      uuid      = var.apex_zside_token[element(local.redundancy, count.index)]
    }
  }
  notifications {
    type        = "ALL"
    emails      = [var.email_user]
  }
}

# ──────────────────────────────────────────────────────────────────────────────────────────
