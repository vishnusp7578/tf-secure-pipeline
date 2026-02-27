resource "google_dns_managed_zone" "public_zone" {
  name     = "public-zone"
  dns_name = "mytf-lab-2026.com."
}

resource "google_dns_record_set" "a_record" { 
  name         = "www.example.com."
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.public_zone.name
  rrdatas      = [var.external_ip]
}

resource "google_dns_managed_zone" "private_zone" {
  name     = "private-zone"
  dns_name = "internal.local."

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = var.network
    }
  }
}

resource "google_dns_record_set" "private_vm_record" {
  name         = "vm-a.internal.local."
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.private_zone.name
  rrdatas      = [var.internal_ip]
}
