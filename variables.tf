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
