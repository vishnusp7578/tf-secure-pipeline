terraform {
  backend "gcs" {
    bucket  = "vsp-tf-state"
    prefix  = "prod"
  }
}
