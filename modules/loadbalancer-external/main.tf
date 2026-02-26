resource "google_compute_instance_template" "web_template" {
  name_prefix  = "ext-web-template"
  machine_type = "e2-medium"

  disk {
    source_image = "debian-cloud/debian-12"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    subnetwork = var.subnet_id
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt update -y
    apt install apache2 -y
    echo "External LB Backend - $(hostname)" > /var/www/html/index.html
  EOF
}

resource "google_compute_region_instance_group_manager" "web_mig" {
  name               = "ext-web-mig"
  region             = var.region
  base_instance_name = "ext-web"
  target_size        = var.instance_count

  version {
    instance_template = google_compute_instance_template.web_template.id
  }
}

resource "google_compute_health_check" "http" {
  name = "ext-http-health-check"

  http_health_check {
    port = 80
  }
}

resource "google_compute_backend_service" "backend" {
  name          = "ext-backend-service"
  protocol      = "HTTP"
  port_name     = "http"
  timeout_sec   = 10
  health_checks = [google_compute_health_check.http.id]

  backend {
    group = google_compute_region_instance_group_manager.web_mig.instance_group
  }
}

resource "google_compute_url_map" "url_map" {
  name            = "ext-url-map"
  default_service = google_compute_backend_service.backend.id
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "ext-http-proxy"
  url_map = google_compute_url_map.url_map.id
}

resource "google_compute_global_address" "lb_ip" {
  name = "external-lb-ip"
}

resource "google_compute_global_forwarding_rule" "http" {
  name       = "ext-http-forwarding-rule"
  target     = google_compute_target_http_proxy.http_proxy.id
  port_range = "80"
  ip_address = google_compute_global_address.lb_ip.address
}
