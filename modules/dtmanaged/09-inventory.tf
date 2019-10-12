//  Collect together all of the output variables needed to build to the final
//  inventory from the inventory template.
data "template_file" "inventory" {
  template = "${file("${path.cwd}/inventory.template.cfg")}"
  vars = {
    access_key = "${aws_iam_access_key.dtmanaged-aws-user.id}"
    secret_key = "${aws_iam_access_key.dtmanaged-aws-user.secret}"
    public_hostname = "${aws_eip.dtmanaged_eip.public_ip}.xip.io"
    dtmanaged_inventory = "${aws_instance.dtmanaged.private_dns}"
    dtmanaged_hostname = "${aws_instance.dtmanaged.private_dns}"
    cluster_id = "${var.cluster_id}"
  }
}

//  Create the inventory.
resource "local_file" "inventory" {
  content     = "${data.template_file.inventory.rendered}"
  filename = "${path.cwd}/inventory.cfg"
}
