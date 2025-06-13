locals {
  setup_vpn_script         = file("${path.module}/setup-vpn.sh")
  add_netplan_script       = file("${path.module}/add-netplan-route.sh")

  setup_vpn_script_indented = join("\n", [for line in split("\n", local.setup_vpn_script) : "      ${line}"])
  add_netplan_script_indented = join("\n", [for line in split("\n", local.add_netplan_script) : "      ${line}"])
}


resource "digitalocean_droplet" "vpn_gateway" {
  image      = var.image
  name       = var.name
  size       = var.size
  monitoring = var.monitoring
  ssh_keys   = var.ssh_keys
  region     = var.region
  vpc_uuid   = var.vpc_id
  tags       = var.tags
  user_data = templatefile("${path.module}/cloud-init-template.yaml", {
    vpn_psk       = var.vpn_psk
    do_vpn_ip     = var.reserved_ip
    remote_vpn_ip = var.remote_vpn_ip
    remote_vpn_cidr = var.remote_vpn_cidr
    setup_vpn_script = local.setup_vpn_script_indented
    add_netplan_script = local.add_netplan_script_indented
  })
}

resource "digitalocean_reserved_ip_assignment" "reserved_ip_assignment" {
  ip_address = var.reserved_ip
  droplet_id = digitalocean_droplet.vpn_gateway.id
}