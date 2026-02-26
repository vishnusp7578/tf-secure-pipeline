output "internal_lb_ip" {
  value = google_compute_forwarding_rule.internal_lb.ip_address
}
