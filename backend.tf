terraform {
  backend "gcs" {
    bucket  = "vishnu-terraform-state"
    prefix  = "prod"
  }
}
