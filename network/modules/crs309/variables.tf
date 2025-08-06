variable "host" {
  description = "Host for CRS309-1G-8S+"
  type        = string
}

variable "ca_cert" {
  description = "CA certificate path for CRS309-1G-8S+"
  type        = string
}

variable "username" {
  description = "Username for CRS309-1G-8S+"
  type        = string
  sensitive   = true
}

variable "password" {
  description = "Password for CRS309-1G-8S+"
  type        = string
  sensitive   = true
}

variable "vlans" {
  description = "VLAN IDs"
  type = object({
    common  = string,
    cluster = string,
    mgmt    = string,
    oobm    = string,
  })
}
