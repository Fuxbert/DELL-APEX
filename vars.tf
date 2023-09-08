# List out your fix variables you won't change frequently.
# Frequently changed variables can be stored in 'terraform.tfvars'
# or will be queried from terraform after 'terraform init' command
# --> see blank values below

# ──────────────────────────────────────────────────────────────────────────────────────────

# METAL RELATED
variable "metal_auth_token" {
  description   = "Metal API auth token. Keep safe and exclude from public repos!"
  sensitive     = true
  type          = string
  } # define in secret.tfvars

variable "metal" {
  description = "Metal details"
  default = {
    metro = "location"
    node = {
      sku = var.metal.node.sku
      os = var.metal.node.os
      term = var.metal.node.term
      }
    project_id = "YOUR_PROJECT_ID"
    service_token = {
      tenancy = "shared"
      redundancy = "redundant"
      type = "a_side"
      }
    }
  }

variable "vlan_id" {
  description   = "Enter the Correct VLAN ID for use with Dell APEX endpoint"
  default = {
    prim = "vlan_a"
    sec = "vlan_b"
    }
  }

variable "apex_zside_token" {
  description = "Primary Z-Side Token for Fabric VC, VLAN 3976"
  default = {
    prim = "token_a"
    sec = "token_b"
    }
  }

variable "ip_address" {
  description = "P2P IP addresses"
  default = {
    metal_prim = "metal_p2p_a"
    metal_sec = "metal_p2p_b"
    apex_prim = "dell_p2p_a"
    apex_sec = "dell_p2p_b"
    }
  }
variable "subnetmask" {
  description   = "Subnetmask for APEX endpoint"
  default       = "cidr"
  }

# ──────────────────────────────────────────────────────────────────────────────────────────

# FABRIC RELATED
variable "fabric_client_id" { 
  description = "Your Equinix Fabric Account Identifyer. Keep safe and exclude from public repos!"
  sensitive = true 
  } # define in secret.tfvars
variable "fabric_client_secret" { 
  description = "Your Equinix Fabric Account Password equivalent. Keep safe and exclude from public repos!"
  sensitive = true 
  } # define in secret.tfvars

variable "bandwidth" {
  description = "Desired Bandwidth of the Virtual Connections"
  default = fabric_vc_bw
  }

variable "email_user" {
  description = "Mandatory, provide list of email addresses to be notified for any changes"
  default = [mailing_list]
  }

# ──────────────────────────────────────────────────────────────────────────────────────────
