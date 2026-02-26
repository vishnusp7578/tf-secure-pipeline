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

variable "project_id" {}
variable "region" { default = "us-central1" }
variable "zone_a" { default = "us-central1-a" }
variable "zone_b" { default = "us-central1-b" }
variable "my_ip" {}
