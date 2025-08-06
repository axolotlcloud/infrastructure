terraform {
  required_providers {
    routeros = {
      source  = "terraform-routeros/routeros"
      version = "1.86.2"
    }
  }
}

provider "routeros" {
  alias          = "crs309"
  hosturl        = var.crs309_host
  ca_certificate = var.crs309_ca_cert
  username       = var.crs309_username
  password       = var.crs309_password
}

provider "routeros" {
  alias          = "rb5009ug"
  hosturl        = var.rb5009ug_host
  ca_certificate = var.rb5009ug_ca_cert
  username       = var.rb5009ug_username
  password       = var.rb5009ug_password
}

locals {
  vlan = {
    common  = "10"
    cluster = "20"
    mgmt    = "99"
    oobm    = "199"
  }
}

resource "routeros_system_clock" "set" {
  provider       = routeros.crs309
  time_zone_name = "America/New_York"
}

resource "routeros_system_ntp_client" "set" {
  provider = routeros.crs309
  enabled  = true
  servers  = ["time.cloudflare.com", "time.nist.gov"]
}

resource "routeros_interface_bridge" "bridge1" {
  provider       = routeros.crs309
  name           = "bridge1"
  frame_types    = "admit-only-vlan-tagged"
  vlan_filtering = true
}

resource "routeros_interface_bridge_port" "sfp-sfpplus8" {
  provider    = routeros.crs309
  bridge      = routeros_interface_bridge.bridge1.name
  interface   = "sfp-sfpplus8"
  frame_types = "admit-only-vlan-tagged"
}

resource "routeros_interface_bridge_vlan" "cluster" {
  provider = routeros.crs309
  bridge   = routeros_interface_bridge.bridge1.name
  vlan_ids = [local.vlan.cluster]
  tagged   = [routeros_interface_bridge_port.sfp-sfpplus8.interface]
}

resource "routeros_interface_bridge_port" "sfp-sfpplus1" {
  provider    = routeros.crs309
  bridge      = routeros_interface_bridge.bridge1.name
  pvid        = local.vlan.cluster
  interface   = "sfp-sfpplus1"
  frame_types = "admit-only-untagged-and-priority-tagged"
}

resource "routeros_interface_bridge_port" "sfp-sfpplus2" {
  provider    = routeros.crs309
  bridge      = routeros_interface_bridge.bridge1.name
  pvid        = local.vlan.cluster
  interface   = "sfp-sfpplus2"
  frame_types = "admit-only-untagged-and-priority-tagged"
}

resource "routeros_interface_bridge_port" "sfp-sfpplus3" {
  provider    = routeros.crs309
  bridge      = routeros_interface_bridge.bridge1.name
  pvid        = local.vlan.cluster
  interface   = "sfp-sfpplus3"
  frame_types = "admit-only-untagged-and-priority-tagged"
}
