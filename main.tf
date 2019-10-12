# Setup our providers so that we have deterministic dependecy resolution. 
provider "aws" {
  region  = "${var.region}"
  version = "~> 2.19"
}

provider "local" {
  version = "~> 1.3"
}

provider "template" {
  version = "~> 2.1"
}

//  Create the Dynatrace Managed cluster using our module.
module "dtmanaged" {
  source          = "./modules/dtmanaged"
  region          = "${var.region}"
  amisize         = "t3.2xlarge"  
  vpc_cidr        = "10.0.0.0/16"
  subnet_cidr     = "10.0.1.0/24"
  key_name        = "dtmanaged-${var.dtmanaged_user}"
  public_key_path = "${var.public_key_path}"
  cluster_name    = "dtmanaged-cluster-${var.dtmanaged_user}"
  cluster_id      = "dtmanaged-cluster-${var.region}"
}

//  Output some useful variables for quick SSH access etc.
output "dtmanaged-url" {
  value = "https://${module.dtmanaged.dtmanaged-public_ip}.xip.io:8443"
}
output "dtmanaged-public_ip" {
  value = "${module.dtmanaged.dtmanaged-public_ip}"
}
output "activegate-public_ip" {
  value = "${module.dtmanaged.activegate-public_ip}"
}
