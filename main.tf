provider "equinix" {
  auth_token    = var.metal_auth_token
  client_id     = var.fabric_client_id
  client_secret = var.fabric_client_secret
}
