
# Terraform Deployer SA


resource "google_service_account" "terraform_sa" {
  account_id   = "terraform-deployer"
  display_name = "Terraform Deployment Service Account"
}

############################
# Custom IAM Role


resource "google_project_iam_custom_role" "terraform_role" {
  role_id     = "terraformDeployerRole"
  title       = "Terraform Deployer Custom Role"
  description = "Least privilege role for Terraform infra deployment"
  project     = var.project_id

  permissions = [

    # Networks
    "compute.networks.create",
    "compute.networks.update",
    "compute.networks.get",
    "compute.networks.delete",

    # Subnets
    "compute.subnetworks.create",
    "compute.subnetworks.update",
    "compute.subnetworks.get",
    "compute.subnetworks.delete",

    # Firewalls
    "compute.firewalls.create",
    "compute.firewalls.update",
    "compute.firewalls.get",
    "compute.firewalls.delete",

    # VM
    "compute.instances.create",
    "compute.instances.update",
    "compute.instances.get",
    "compute.instances.delete",

    # Routes
    "compute.routes.create",
    "compute.routes.delete",
    "compute.routes.get",

    # Routers / NAT
    "compute.routers.create",
    "compute.routers.update",
    "compute.routers.get",
    "compute.routers.delete",

    # VPN
    "compute.vpnGateways.create",
    "compute.vpnGateways.get",
    "compute.vpnGateways.delete",
    "compute.vpnTunnels.create",
    "compute.vpnTunnels.get",
    "compute.vpnTunnels.delete",

    # Load Balancer
    "compute.backendServices.create",
    "compute.backendServices.get",
    "compute.backendServices.delete",
    "compute.urlMaps.create",
    "compute.urlMaps.get",
    "compute.urlMaps.delete",
    "compute.targetHttpProxies.create",
    "compute.targetHttpProxies.get",
    "compute.targetHttpProxies.delete",
    "compute.forwardingRules.create",
    "compute.forwardingRules.get",
    "compute.forwardingRules.delete",

    # DNS
    "dns.managedZones.create",
    "dns.managedZones.delete",
    "dns.managedZones.get",
    "dns.resourceRecordSets.create",
    "dns.resourceRecordSets.delete",
    "dns.resourceRecordSets.list",

    # Project Read
    "resourcemanager.projects.get"
  ]
}

############################
#Bind Custom Role to Terraform SA


resource "google_project_iam_member" "terraform_role_binding" {
  project = var.project_id
  role    = google_project_iam_custom_role.terraform_role.name
  member  = "serviceAccount:${google_service_account.terraform_sa.email}"
}

############################
#Storage Access (State Bucket)


resource "google_project_iam_member" "state_bucket_access" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.terraform_sa.email}"
}

############################
#Allow Cloud Build to Impersonate Terraform SA


resource "google_service_account_iam_member" "allow_impersonation" {
  service_account_id = google_service_account.terraform_sa.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${var.cloudbuild_sa_email}"
}
