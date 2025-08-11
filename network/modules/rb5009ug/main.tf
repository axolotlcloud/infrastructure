resource "routeros_ip_address" "wan" {
  address   = "192.168.1.42/24"
  interface = "ether8"
}

resource "routeros_ip_route" "default" {
  dst_address = "0.0.0.0/0"
  gateway     = "192.168.1.1"
}

resource "routeros_ip_dns" "set" {
  allow_remote_requests = true
  servers = [
    "2606:4700:4700::1111",
    "1.1.1.1",
    "2606:4700:4700::1001",
    "1.0.0.1",
  ]
}

resource "routeros_system_clock" "set" {
  time_zone_name = "America/New_York"
}

resource "routeros_system_ntp_client" "set" {
  enabled = true
  servers = ["time.cloudflare.com", "time.nist.gov"]
}

resource "routeros_ip_dns_record" "oobm_ax0_lan_axolotl_cloud_A" {
  type    = "A"
  name    = "oobm.ax0.lan.axolotl.cloud"
  address = "10.0.99.10"
  ttl     = "30s"
}

resource "routeros_ip_dns_record" "oobm_ax1_lan_axolotl_cloud_A" {
  type    = "A"
  name    = "oobm.ax1.lan.axolotl.cloud"
  address = "10.0.99.11"
  ttl     = "30s"
}

resource "routeros_ip_dns_record" "oobm_ax2_lan_axolotl_cloud_A" {
  type    = "A"
  name    = "oobm.ax2.lan.axolotl.cloud"
  address = "10.0.99.12"
  ttl     = "30s"
}

resource "routeros_ip_dns_record" "k8s_lan_axolotl_cloud_A_0" {
  type    = "A"
  name    = "k8s.lan.axolotl.cloud"
  address = "10.0.10.10"
  ttl     = "30s"
}

resource "routeros_ip_dns_record" "k8s_lan_axolotl_cloud_A_1" {
  type    = "A"
  name    = "k8s.lan.axolotl.cloud"
  address = "10.0.10.11"
  ttl     = "30s"
}

resource "routeros_ip_dns_record" "k8s_lan_axolotl_cloud_A_2" {
  type    = "A"
  name    = "k8s.lan.axolotl.cloud"
  address = "10.0.10.12"
  ttl     = "30s"
}

resource "routeros_ip_dns_record" "gateway_lan_axolotl_cloud_A" {
  type    = "A"
  name    = "gateway.lan.axolotl.cloud"
  address = "10.0.11.0"
  ttl     = "30s"
}

resource "routeros_ip_dns_record" "argocd_lan_axolotl_cloud_CNAME" {
  type  = "CNAME"
  name  = "argocd.lan.axolotl.cloud"
  cname = "gateway.lan.axolotl.cloud"
  ttl   = "30s"
}

resource "routeros_ip_dns_record" "ceph_lan_axolotl_cloud_CNAME" {
  type  = "CNAME"
  name  = "ceph.lan.axolotl.cloud"
  cname = "gateway.lan.axolotl.cloud"
  ttl   = "30s"
}

resource "routeros_ip_dns_record" "grafana_lan_axolotl_cloud_CNAME" {
  type  = "CNAME"
  name  = "grafana.lan.axolotl.cloud"
  cname = "gateway.lan.axolotl.cloud"
  ttl   = "30s"
}

resource "routeros_ip_dns_record" "hubble_lan_axolotl_cloud_CNAME" {
  type  = "CNAME"
  name  = "hubble.lan.axolotl.cloud"
  cname = "gateway.lan.axolotl.cloud"
  ttl   = "30s"
}

resource "routeros_ip_dns_record" "s3_lan_axolotl_cloud_CNAME" {
  type  = "CNAME"
  name  = "s3.lan.axolotl.cloud"
  cname = "gateway.lan.axolotl.cloud"
  ttl   = "30s"
}

resource "routeros_ip_dns_record" "whoami_lan_axolotl_cloud_CNAME" {
  type  = "CNAME"
  name  = "whoami.lan.axolotl.cloud"
  cname = "gateway.lan.axolotl.cloud"
  ttl   = "30s"
}

resource "routeros_interface_bridge" "bridge1" {
  name           = "bridge1"
  frame_types    = "admit-only-vlan-tagged"
  vlan_filtering = true
}

resource "routeros_interface_bridge_vlan" "common" {
  bridge   = routeros_interface_bridge.bridge1.name
  vlan_ids = [var.vlans.common]
  tagged   = [routeros_interface_bridge.bridge1.name]
}

resource "routeros_interface_vlan" "common" {
  interface = routeros_interface_bridge.bridge1.name
  name      = "COMMON"
  vlan_id   = var.vlans.common
}

resource "routeros_ip_address" "common" {
  address   = "10.0.1.1/24"
  interface = routeros_interface_vlan.common.name
}

resource "routeros_interface_bridge_port" "ether2" {
  bridge      = routeros_interface_bridge.bridge1.name
  pvid        = var.vlans.common
  interface   = "ether2"
  frame_types = "admit-only-untagged-and-priority-tagged"
}

resource "routeros_interface_bridge_port" "ether3" {
  bridge      = routeros_interface_bridge.bridge1.name
  pvid        = var.vlans.common
  interface   = "ether3"
  frame_types = "admit-only-untagged-and-priority-tagged"
}

resource "routeros_interface_bridge_port" "ether4" {
  bridge      = routeros_interface_bridge.bridge1.name
  pvid        = var.vlans.common
  interface   = "ether4"
  frame_types = "admit-only-untagged-and-priority-tagged"
}

resource "routeros_interface_bridge_port" "sfp-sfpplus1" {
  bridge      = routeros_interface_bridge.bridge1.name
  interface   = "sfp-sfpplus1"
  frame_types = "admit-only-vlan-tagged"
}

resource "routeros_interface_bridge_vlan" "cluster" {
  bridge   = routeros_interface_bridge.bridge1.name
  vlan_ids = [var.vlans.cluster]
  tagged = [
    routeros_interface_bridge.bridge1.name,
    routeros_interface_bridge_port.sfp-sfpplus1.interface,
  ]
}

resource "routeros_interface_vlan" "cluster" {
  interface = routeros_interface_bridge.bridge1.name
  name      = "CLUSTER"
  vlan_id   = var.vlans.cluster
}

resource "routeros_ip_address" "cluster" {
  address   = "10.0.10.1/24"
  interface = routeros_interface_vlan.cluster.name
}

resource "routeros_interface_bridge_vlan" "mgmt" {
  bridge   = routeros_interface_bridge.bridge1.name
  vlan_ids = [var.vlans.mgmt]
  tagged = [
    routeros_interface_bridge.bridge1.name,
    routeros_interface_bridge_port.sfp-sfpplus1.interface,
  ]
}

resource "routeros_interface_vlan" "mgmt" {
  interface = routeros_interface_bridge.bridge1.name
  name      = "MGMT"
  vlan_id   = var.vlans.mgmt
}

resource "routeros_ip_address" "mgmt" {
  address   = "10.0.0.1/24"
  interface = routeros_interface_vlan.mgmt.name
}

resource "routeros_interface_bridge_port" "ether5" {
  bridge      = routeros_interface_bridge.bridge1.name
  pvid        = var.vlans.oobm
  interface   = "ether5"
  frame_types = "admit-only-untagged-and-priority-tagged"
}

resource "routeros_interface_bridge_port" "ether6" {
  bridge      = routeros_interface_bridge.bridge1.name
  pvid        = var.vlans.oobm
  interface   = "ether6"
  frame_types = "admit-only-untagged-and-priority-tagged"
}

resource "routeros_interface_bridge_port" "ether7" {
  bridge      = routeros_interface_bridge.bridge1.name
  pvid        = var.vlans.oobm
  interface   = "ether7"
  frame_types = "admit-only-untagged-and-priority-tagged"
}

resource "routeros_interface_bridge_vlan" "oobm" {
  bridge   = routeros_interface_bridge.bridge1.name
  vlan_ids = [var.vlans.oobm]
  tagged   = [routeros_interface_bridge.bridge1.name]
}

resource "routeros_interface_vlan" "oobm" {
  interface = routeros_interface_bridge.bridge1.name
  name      = "OOBM"
  vlan_id   = var.vlans.oobm
}

resource "routeros_ip_address" "oobm" {
  address   = "10.0.99.1/24"
  interface = routeros_interface_vlan.oobm.name
}

resource "routeros_ip_pool" "dhcp_oobm" {
  name   = "DHCP_OOBM"
  ranges = ["10.0.99.10-10.0.99.99"]
}

resource "routeros_ip_dhcp_server_network" "oobm" {
  address    = "10.0.99.0/24"
  gateway    = "10.0.99.1"
  dns_server = ["10.0.99.1"]
}

resource "routeros_ip_dhcp_server" "oobm" {
  address_pool = routeros_ip_pool.dhcp_oobm.name
  interface    = routeros_interface_vlan.oobm.name
  name         = "DHCP_OOBM"
}

resource "routeros_ip_firewall_nat" "wan-srcnat-masq" {
  action        = "masquerade"
  chain         = "srcnat"
  out_interface = routeros_ip_address.wan.interface
}

resource "routeros_ip_firewall_nat" "wan-dstnat-80-tcp" {
  action       = "dst-nat"
  chain        = "dstnat"
  in_interface = routeros_ip_address.wan.interface
  port         = "80"
  protocol     = "tcp"
  to_addresses = "10.0.1.4"
}

resource "routeros_ip_firewall_nat" "wan-dstnat-443-tcp" {
  action       = "dst-nat"
  chain        = "dstnat"
  in_interface = routeros_ip_address.wan.interface
  port         = "443"
  protocol     = "tcp"
  to_addresses = "10.0.1.4"
}

resource "routeros_ip_firewall_nat" "wan-dstnat-32766-tcp" {
  action       = "dst-nat"
  chain        = "dstnat"
  in_interface = routeros_ip_address.wan.interface
  port         = "32766"
  protocol     = "tcp"
  to_addresses = "10.0.1.4"
}

resource "routeros_ip_firewall_nat" "wan-dstnat-32767-tcp" {
  action       = "dst-nat"
  chain        = "dstnat"
  in_interface = routeros_ip_address.wan.interface
  port         = "32767"
  protocol     = "tcp"
  to_addresses = "10.0.1.4"
}

resource "routeros_ip_firewall_nat" "wan-dstnat-6443-tcp" {
  action       = "dst-nat"
  chain        = "dstnat"
  in_interface = routeros_ip_address.wan.interface
  port         = "6443"
  protocol     = "tcp"
  to_addresses = "10.0.1.4"
}

resource "routeros_ip_firewall_nat" "wan-dstnat-8472-tcp" {
  action       = "dst-nat"
  chain        = "dstnat"
  in_interface = routeros_ip_address.wan.interface
  port         = "8472"
  protocol     = "tcp"
  to_addresses = "10.0.1.4"
}

resource "routeros_ip_firewall_nat" "wan-dstnat-10250-tcp" {
  action       = "dst-nat"
  chain        = "dstnat"
  in_interface = routeros_ip_address.wan.interface
  port         = "10250"
  protocol     = "tcp"
  to_addresses = "10.0.1.4"
}

resource "routeros_ip_firewall_filter" "rule-0010" {
  action           = "fasttrack-connection"
  chain            = "forward"
  connection_state = "established,related"
  hw_offload       = true
  comment          = "fast-track for established,related"
}

resource "routeros_ip_firewall_filter" "rule-0020" {
  action           = "accept"
  chain            = "forward"
  connection_state = "established,related"
  comment          = "accept established,related"
}

resource "routeros_ip_firewall_filter" "rule-0030" {
  action           = "drop"
  chain            = "forward"
  connection_state = "invalid"
  comment          = "drop invalid"
}

resource "routeros_ip_firewall_filter" "rule-0040" {
  action               = "drop"
  chain                = "forward"
  connection_state     = "new"
  connection_nat_state = "!dstnat"
  in_interface         = routeros_ip_address.wan.interface
  comment              = "drop access to clients behind NAT from WAN"
}

resource "routeros_interface_list" "netmgmt" {
  name = "NETMGMT"
}

resource "routeros_interface_list_member" "netmgmt-common" {
  list      = routeros_interface_list.netmgmt.name
  interface = routeros_interface_vlan.common.name
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

resource "routeros_routing_bgp_template" "default" {
  name      = "default"
  as        = "64512"
  router_id = "10.0.10.1"
}

resource "routeros_routing_bgp_connection" "axolotl-0" {
  name           = "axolotl-0"
  as             = routeros_routing_bgp_template.default.as
  router_id      = routeros_routing_bgp_template.default.router_id
  keepalive_time = "3s"
  hold_time      = "9s"
  templates      = [routeros_routing_bgp_template.default.name]
  local {
    role = "ebgp"
  }
  remote {
    address = "10.0.10.10/32"
  }
}

resource "routeros_routing_bgp_connection" "axolotl-1" {
  name           = "axolotl-1"
  as             = routeros_routing_bgp_template.default.as
  router_id      = routeros_routing_bgp_template.default.router_id
  keepalive_time = "3s"
  hold_time      = "9s"
  templates      = [routeros_routing_bgp_template.default.name]
  local {
    role = "ebgp"
  }
  remote {
    address = "10.0.10.11/32"
  }
}

resource "routeros_routing_bgp_connection" "axolotl-2" {
  name           = "axolotl-2"
  as             = routeros_routing_bgp_template.default.as
  router_id      = routeros_routing_bgp_template.default.router_id
  keepalive_time = "3s"
  hold_time      = "9s"
  templates      = [routeros_routing_bgp_template.default.name]
  local {
    role = "ebgp"
  }
  remote {
    address = "10.0.10.12/32"
  }
}

resource "routeros_interface_wireguard" "warp" {
  name        = "WARP"
  mtu         = "1420"
  listen_port = "13231"
  private_key = var.warp_private_key
}

resource "routeros_interface_wireguard_peer" "cloudflare-pop" {
  name       = "cloudflare-pop"
  interface  = routeros_interface_wireguard.warp.name
  public_key = var.warp_public_key
  allowed_address = [
    "0.0.0.0/0",
    "::/0",
  ]
  endpoint_address     = "162.159.193.6"
  endpoint_port        = "2408"
  persistent_keepalive = "1m"
}

resource "routeros_ip_address" "warp" {
  address   = "100.96.0.6/12"
  interface = routeros_interface_wireguard.warp.name
}
