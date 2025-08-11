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

variable "warp_public_key" {
  description = "Cloudflare WARP PoP public key"
  type        = string
}

variable "warp_private_key" {
  description = "Cloudflare WARP client private key"
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
