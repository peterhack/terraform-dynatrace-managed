//  Wherever possible, we will use a common set of tags for resources. This
//  makes it much easier to set up resource based billing, tag based access,
//  resource groups and more.
//
//  We are also required to set certain tags on resources to support Kubernetes
//  and AWS integration, which is needed for dynamic volume provisioning.
//
//  This is quite fiddly, the following resources should be useful:
//
//    - Terraform: Local Values: https://www.terraform.io/docs/configuration/locals.html
//    - Terraform: Default Tags for Resources in Terraform: https://github.com/hashicorp/terraform/issues/2283
//    - Terraform: Variable Interpolation for Tags: https://github.com/hashicorp/terraform/issues/14516
                                        
//  Define our common tags.
//   - Project: Purely for my own organisation, delete or change as you like!
//  The syntax below is ugly, but needed as we are using dynamic key names.
locals {
  common_tags = "${map(
    "Workshop", "workshop-${var.dtm_workshop}",
    "Project", "dtmanaged-workshop-${var.dtmanaged_user}",
    "Owner" , "${var.dtmanaged_user_email}"
  )}"
}
