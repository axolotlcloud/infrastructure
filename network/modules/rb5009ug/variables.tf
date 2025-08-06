variable "host" {
  description = "Host for RB5009UG+S+IN"
  type        = string
}

variable "ca_cert" {
  description = "CA certificate path for RB5009UG+S+IN"
  type        = string
}

variable "username" {
  description = "Username for RB5009UG+S+IN"
  type        = string
  sensitive   = true
}

variable "password" {
  description = "Password for RB5009UG+S+IN"
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
