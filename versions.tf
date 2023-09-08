terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
    equinix = {
      source  = "equinix/equinix"
      version = "1.16.0"
    }
  }
}
