variable "network" {}
variable "region" {}
variable "peer_ip" {}
variable "shared_secret" {}

resource "google_compute_address" "vpn_ip" {
  name   = "vpn-gateway-ip"
  region = var.region
}
resource "google_compute_vpn_gateway" "vpn_gw" {
  name    = "vpn-gateway"
  network = var.network
  region  = var.region
}

resource "google_compute_forwarding_rule" "vpn_ike" {
  name       = "vpn-ike"
  region     = var.region
  target     = google_compute_vpn_gateway.vpn_gw.id
  ip_protocol = "UDP"
  ports      = ["500"]
  ip_address = google_compute_address.vpn_ip.address
}

resource "google_compute_forwarding_rule" "vpn_nat_t" {
  name       = "vpn-nat-t"
  region     = var.region
  target     = google_compute_vpn_gateway.vpn_gw.id
  ip_protocol = "UDP"
  ports      = ["4500"]
  network    = var.network
}

resource "google_compute_forwarding_rule" "vpn_esp" {
  name        = "vpn-esp"
  region      = var.region
  target      = google_compute_vpn_gateway.vpn_gw.id
  ip_protocol = "ESP"
  network     = var.network
}

resource "google_compute_vpn_tunnel" "tunnel" {
  name               = "vpn-tunnel"
  region             = var.region
  target_vpn_gateway = google_compute_vpn_gateway.vpn_gw.id
  peer_ip            = var.peer_ip
  shared_secret      = var.shared_secret
}
