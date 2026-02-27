variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1" 
}

variable "cloudbuild_sa_email" {
  description = "Cloud Build Service Account Email"
  type        = string
}

variable "zone_a" { default = "us-central1-a" }
variable "zone_b" { default = "us-central1-b" }
variable "my_ip" {}
variable "vpn_shared_secret" {}

variable "local_subnet_cidr" {
  type = list(string)
}

variable "remote_subnet_cidr" {
  type = list(string)
}
