provider "routeros" {
  hosturl        = var.host
  ca_certificate = var.ca_cert
  username       = var.username
  password       = var.password
}
