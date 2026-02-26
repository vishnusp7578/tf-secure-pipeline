resource "google_compute_network" "vpc" {
  name                    = var.name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnets" {
  for_each = var.subnets

  name          = each.key
  ip_cidr_range = each.value
  region        = var.region
  network       = google_compute_network.vpc.id
}

output "network" {
  value = google_compute_network.vpc.id
}

output "subnets" {
  value = google_compute_subnetwork.subnets
}
