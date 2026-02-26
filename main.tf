module "iam" {
  source = "./modules/IAM"

  project_id          = var.project_id
  cloudbuild_sa_email = var.cloudbuild_sa_email
}
