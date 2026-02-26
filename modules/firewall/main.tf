variable "network" {}
variable "my_ip" {}

resource "google_compute_firewall" "ssh" { 
  name    = "allow-ssh"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [var.my_ip]
  target_tags   = ["ssh"]
}

resource "google_compute_firewall" "http" {
  name    = "allow-http"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["80","443"]
  }
}

resource "google_compute_firewall" "lb_health_check" {
  name    = "allow-lb-health-check"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  # Google LB health check IP ranges
  source_ranges = [
    "130.211.0.0/22",
    "35.191.0.0/16"
  ]

  target_tags = ["web"]
}

resource "google_compute_firewall" "ssh_iap" {
  name    = "allow-ssh-iap"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # Required source range for IAP TCP forwarding
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["ssh"]
}

