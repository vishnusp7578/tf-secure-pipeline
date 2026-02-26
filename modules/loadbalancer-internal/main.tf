resource "google_compute_instance" "internal_vm" {
  name         = "internal-backend-vm"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = var.subnet_id
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt update -y
    apt install apache2 -y
    echo "Internal LB Backend" > /var/www/html/index.html
  EOF
}

resource "google_compute_instance_group" "internal_group" {
  name = "internal-instance-group"
  zone = var.zone

  instances = [google_compute_instance.internal_vm.id]
}
resource "google_compute_health_check" "tcp" {
  name = "internal-tcp-health-check"

  tcp_health_check {
    port = 80
  }
}

resource "google_compute_region_backend_service" "internal_backend" {
  name                  = "internal-backend-service"
  region                = var.region
  protocol              = "TCP"
  load_balancing_scheme = "INTERNAL"
  health_checks         = [google_compute_health_check.tcp.id]

  backend {
    group = google_compute_instance_group.internal_group.id
  }
}

resource "google_compute_forwarding_rule" "internal_lb" {
  name                  = "internal-lb"
  region                = var.region
  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.internal_backend.id
  ports                 = ["80"]
  subnetwork            = var.subnet_id
}

