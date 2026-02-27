resource "routeros_ip_route" "default" {
  dst_address = "0.0.0.0/0"
  gateway     = "10.0.0.1"
}

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

resource "routeros_interface_vlan" "mgmt" {
  interface = routeros_interface_bridge.bridge1.name
  name      = "MGMT"
  vlan_id   = var.vlans.mgmt
}

resource "routeros_ip_address" "mgmt" {
  address   = "10.0.0.2/24"
  interface = routeros_interface_vlan.mgmt.name
}

resource "routeros_interface_bridge_vlan" "mgmt" {
  bridge   = routeros_interface_bridge.bridge1.name
  vlan_ids = [var.vlans.mgmt]
  tagged   = [
    routeros_interface_bridge.bridge1.name,
    routeros_interface_bridge_port.sfp-sfpplus8.interface
  ]
}

resource "routeros_interface_bridge_port" "ether1" {
  bridge      = routeros_interface_bridge.bridge1.name
  pvid        = var.vlans.mgmt
  interface   = "ether1"
  frame_types = "admit-only-untagged-and-priority-tagged"
}

resource "routeros_interface_list" "netmgmt" {
  name = "NETMGMT"
}

resource "routeros_interface_list_member" "netmgmt-mgmt" {
  list      = routeros_interface_list.netmgmt.name
  interface = routeros_interface_vlan.mgmt.name
}

resource "routeros_tool_mac_server" "set" {
  allowed_interface_list = routeros_interface_list.netmgmt.name
}

resource "routeros_tool_mac_server_winbox" "set" {
  allowed_interface_list = routeros_interface_list.netmgmt.name
}

resource "routeros_ip_neighbor_discovery_settings" "set" {
  discover_interface_list = routeros_interface_list.netmgmt.name
}

resource "routeros_ip_service" "ftp" {
  numbers  = "ftp"
  port     = 21
  disabled = true
}

resource "routeros_ip_service" "telnet" {
  numbers  = "telnet"
  port     = 23
  disabled = true
}

resource "routeros_tool_bandwidth_server" "set" {
  enabled = false
}

resource "routeros_ip_ssh_server" "set" {
  strong_crypto = true
}
