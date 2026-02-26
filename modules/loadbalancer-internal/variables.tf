variable "region" {
  type        = string
  description = "GCP region"
}

variable "zone" {
  type        = string
  description = "GCP zone"
}

variable "vpc_id" {
  type        = string
  description = "VPC network ID for internal LB"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for internal LB backend"
}
