resource "google_compute_instance" "vm" {
  name         = var.name
  machine_type = "e2-medium"
  zone         = var.zone
  tags         = var.tags

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"   
    }
  }

  network_interface {
    subnetwork = var.subnet.self_link

    dynamic "access_config" {
      for_each = var.external_ip ? [1] : []
      content {}
    }
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt update -y
    apt install apache2 -y
    echo "Hello from ${var.name}" > /var/www/html/index.html
  EOF
}

output "external_ip" {
  value = try(google_compute_instance.vm.network_interface[0].access_config[0].nat_ip, null)
}

output "internal_ip" {
  value = google_compute_instance.vm.network_interface[0].network_ip
}
