variable "crs309_host" {
  description = "Host for CRS309-1G-8S+"
  type        = string
}

variable "crs309_ca_cert" {
  description = "CA certificate path for CRS309-1G-8S+"
  type        = string
}

variable "crs309_username" {
  description = "Username for CRS309-1G-8S+"
  type        = string
  sensitive   = true
}

variable "crs309_password" {
  description = "Password for CRS309-1G-8S+"
  type        = string
  sensitive   = true
}

variable "rb5009ug_host" {
  description = "Host for RB5009UG+S+IN"
  type        = string
}

variable "rb5009ug_ca_cert" {
  description = "CA certificate path for RB5009UG+S+IN"
  type        = string
}

variable "rb5009ug_username" {
  description = "Username for RB5009UG+S+IN"
  type        = string
  sensitive   = true
}

variable "rb5009ug_password" {
  description = "Password for RB5009UG+S+IN"
  type        = string
  sensitive   = true
}
