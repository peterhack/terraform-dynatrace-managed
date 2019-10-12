//  The region we will deploy our cluster into.
variable "region" {
  description = "Region to deploy the cluster into"
  default = "us-west-1"
}

//  The public key to use for SSH access.
variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

// Additional Idenitification for created AWS objects - uncomment to use
variable "dtmanaged_user" {
  default = "phack"
}
					
variable "dtmanaged_user_email" {
  default = "peter.hack@dynatrace.com"
}

variable "dtm_workshop" {
  default = "m2m-madison"
}
