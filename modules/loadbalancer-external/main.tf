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
