variable "network" {}
variable "region" {}
variable "peer_ip" {}
variable "shared_secret" {}

resource "google_compute_vpn_gateway" "vpn_gw" {
  name    = "vpn-gateway"
  network = var.network
  region  = var.region
}

resource "google_compute_vpn_tunnel" "tunnel" {
  name               = "vpn-tunnel"
  region             = var.region
  target_vpn_gateway = google_compute_vpn_gateway.vpn_gw.id
  peer_ip            = var.peer_ip
  shared_secret      = var.shared_secret
}
