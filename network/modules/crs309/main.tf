resource "routeros_system_clock" "set" {
  time_zone_name = "America/New_York"
}

resource "routeros_system_ntp_client" "set" {
  enabled = true
  servers = ["time.cloudflare.com", "time.nist.gov"]
}

resource "routeros_interface_bridge" "bridge1" {
  name           = "bridge1"
  frame_types    = "admit-only-vlan-tagged"
  vlan_filtering = true
}

resource "routeros_interface_bridge_port" "sfp-sfpplus8" {
  bridge      = routeros_interface_bridge.bridge1.name
  interface   = "sfp-sfpplus8"
  frame_types = "admit-only-vlan-tagged"
}

resource "routeros_interface_bridge_vlan" "cluster" {
  bridge   = routeros_interface_bridge.bridge1.name
  vlan_ids = [var.vlans.cluster]
  tagged   = [routeros_interface_bridge_port.sfp-sfpplus8.interface]
}

resource "routeros_interface_bridge_port" "sfp-sfpplus1" {
  bridge      = routeros_interface_bridge.bridge1.name
  pvid        = var.vlans.cluster
  interface   = "sfp-sfpplus1"
  frame_types = "admit-only-untagged-and-priority-tagged"
}

resource "routeros_interface_bridge_port" "sfp-sfpplus2" {
  bridge      = routeros_interface_bridge.bridge1.name
  pvid        = var.vlans.cluster
  interface   = "sfp-sfpplus2"
  frame_types = "admit-only-untagged-and-priority-tagged"
}

resource "routeros_interface_bridge_port" "sfp-sfpplus3" {
  bridge      = routeros_interface_bridge.bridge1.name
  pvid        = var.vlans.cluster
  interface   = "sfp-sfpplus3"
  frame_types = "admit-only-untagged-and-priority-tagged"
}
