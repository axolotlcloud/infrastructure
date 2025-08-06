locals {
  vlans = {
    common  = "10"
    cluster = "20"
    mgmt    = "99"
    oobm    = "199"
  }
}

module "crs309" {
  source = "./modules/crs309"

  host     = var.crs309_host
  ca_cert  = var.crs309_ca_cert
  username = var.crs309_username
  password = var.crs309_password

  vlans = local.vlans
}

module "rb5009ug" {
  source = "./modules/rb5009ug"

  host     = var.rb5009ug_host
  ca_cert  = var.rb5009ug_ca_cert
  username = var.rb5009ug_username
  password = var.rb5009ug_password

  vlans = local.vlans
}
