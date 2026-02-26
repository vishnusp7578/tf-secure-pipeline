variable "network" {}
variable "region" {}
variable "peer_ip" {}
variable "shared_secret" {}
variable "local_subnet_cidr" {
type        = list(string)
}

variable "remote_subnet_cidr" {
type        = list(string)
}

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
  port_range      = "500"
  ip_address = google_compute_address.vpn_ip.address
}

resource "google_compute_forwarding_rule" "vpn_nat_t" {
  name       = "vpn-nat-t"
  region     = var.region
  ip_address = google_compute_address.vpn_ip.address
  target     = google_compute_vpn_gateway.vpn_gw.id
  ip_protocol = "UDP"
  port_range   = "4500"
}

resource "google_compute_forwarding_rule" "vpn_esp" {
  name        = "vpn-esp"
  region      = var.region
  ip_address = google_compute_address.vpn_ip.address
  target      = google_compute_vpn_gateway.vpn_gw.id
  ip_protocol = "ESP"
}

resource "google_compute_vpn_tunnel" "tunnel" {
  name               = "vpn-tunnel"
  region             = var.region
  target_vpn_gateway = google_compute_vpn_gateway.vpn_gw.id
  peer_ip            = var.peer_ip
  shared_secret      = var.shared_secret
  local_traffic_selector  = var.local_subnet_cidr   
  remote_traffic_selector = var.remote_subnet_cidr 
depends_on = [
    google_compute_forwarding_rule.vpn_esp,
    google_compute_forwarding_rule.vpn_ike,
    google_compute_forwarding_rule.vpn_nat_t
  ]

}
