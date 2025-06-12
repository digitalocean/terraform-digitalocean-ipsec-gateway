variable "name" {
  description = "Name of the VPN GW Droplet"
  type        = string
}

variable "region" {
  description = "DO region slug for the region the droplet will be deployed into"
  type        = string
}

variable "size" {
  description = "DO size slug used for the droplet"
  type        = string
}

variable "image" {
  description = "DO image slug to run on the droplet, must be ubuntu based."
  type        = string

  validation {
    condition     = startswith(var.image, "ubuntu")
    error_message = "The image slug must start with 'ubuntu'."
  }
}

variable "monitoring" {
  description = "Whether monitoring agent is installed"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "Id of the VPC which the Droplet is connected to"
  type        = string
}

variable "ssh_keys" {
  description = "A list of SSH key IDs to enable in the format [12345, 123456]"
  type        = list(number)
  default     = []
}

variable "tags" {
  description = "A list of the tags to be applied to this Droplet"
  type        = list(string)
  default     = []
}

variable "vpn_psk" {
  description = "pre-shared key used for the VPN tunnel"
  type        = string
  sensitive   = true
}

variable "reserved_ip" {
  description = "The IP address of the reserved IP that will be used as the VPN endpoint on the DO site"
  type        = string
  validation {
    condition     = can(cidrnetmask(join("/", [var.reserved_ip, "32"])))
    error_message = "Must be a valid IPv4 address."
  }
}

variable "remote_vpn_ip" {
  description = "The IP address of the IP that will be used as the VPN endpoint on the remote site"
  type        = string
  validation {
    condition     = can(cidrnetmask(join("/", [var.remote_vpn_ip, "32"])))
    error_message = "Must be a valid IPv4 address."
  }
}
