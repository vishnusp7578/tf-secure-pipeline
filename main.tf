module "iam" {
  source = "./modules/IAM"

  project_id          = var.project_id
  cloudbuild_sa_email = var.cloudbuild_sa_email 
}


#VPC 1
module "vpc1" {
  source = "./modules/vpc"

  name   = "vpc-1"
  region = var.region

  subnets = {
    subnet-a = "10.0.1.0/24"
    subnet-b = "10.0.2.0/24"
  }
}


#VPC 2 (for peering & VPN )

module "vpc2" {
  source = "./modules/vpc"

  name   = "vpc-2"
  region = var.region

  subnets = {
    subnet-c = "10.10.1.0/24"
  }
}


#VMs

module "vm_a" {
  source  = "./modules/vm"
  name    = "vm-a"
  zone    = var.zone_a
  subnet  = module.vpc1.subnets["subnet-a"]
  tags    = ["ssh","web"]
  external_ip = true
}

module "vm_b" {
  source  = "./modules/vm"
  name    = "vm-b"
  zone    = var.zone_b
  subnet  = module.vpc1.subnets["subnet-b"]
  tags    = ["private"]
  external_ip = false
}


#Firewall

module "firewall" {
  source  = "./modules/firewall"
  network = module.vpc1.network

  my_ip = var.my_ip
}


#NAT

module "nat" {
  source  = "./modules/nat"
  network = module.vpc1.network 
  region  = var.region
}

module "peering1" {
  source       = "./modules/peering"
  name         = "peer-1"
  network      = module.vpc1.network
  peer_network = module.vpc2.network
}

module "peering2" {
  source       = "./modules/peering"
  name         = "peer-2"
  network      = module.vpc2.network
  peer_network = module.vpc1.network
}

module "vpn" {
  source            = "./modules/vpn"
  network           = module.vpc1.network
  region            = var.region
  peer_ip           = module.vm_a.external_ip
  shared_secret     = var.vpn_shared_secret
  local_subnet_cidr  = ["10.0.0.0/16"]
  remote_subnet_cidr = ["10.1.0.0/16"]
}

module "external_lb" {
  source     = "./modules/loadbalancer-external"
  project_id = var.project_id
  region     = var.region
  vpc_id     = module.vpc1.network
  subnet_id  = module.vpc1.subnets["subnet-a"].id
}

module "internal_lb" {
  source    = "./modules/loadbalancer-internal"
  region    = var.region
  zone      = var.zone_a
  vpc_id    = module.vpc1.network
  subnet_id = module.vpc1.subnets["subnet-b"].id
}

module "dns" {
  source      = "./modules/dns"
  network     = module.vpc1.network
  external_ip = module.vm_a.external_ip
}
