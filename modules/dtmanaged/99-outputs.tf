//  Output some useful variables for quick SSH access etc.
output "dtmanaged-public_ip" {
  value = "${aws_eip.dtmanaged_eip.public_ip}"
}
output "dtmanaged-private_dns" {
  value = "${aws_instance.dtmanaged.private_dns}"
}
output "dtmanaged-private_ip" {
  value = "${aws_instance.dtmanaged.private_ip}"
}

output "activegate-public_ip" {
  value = "${aws_eip.activegate_eip.public_ip}"
}
output "activegate-private_dns" {
  value = "${aws_instance.activegate.private_dns}"
}
output "activegate-private_ip" {
  value = "${aws_instance.activegate.private_ip}"
}
