//  Launch configuration for the consul cluster auto-scaling group.
resource "aws_eip" "activegate_eip" {
  instance = "${aws_instance.activegate.id}"
  vpc      = true
}

resource "aws_instance" "activegate" {
  ami                  = "${data.aws_ami.amazonlinux.id}"
  instance_type        = "t2.small"
  iam_instance_profile = "${aws_iam_instance_profile.activegate-instance-profile.id}"
  subnet_id            = "${aws_subnet.public-subnet.id}"

  vpc_security_group_ids = [
    "${aws_security_group.dtmanaged-vpc.id}",
    "${aws_security_group.dtmanaged-ssh.id}",
    "${aws_security_group.dtmanaged-public-egress.id}",
  ]

  key_name = "${aws_key_pair.keypair.key_name}"

  //  Use our common tags and add a specific name.
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "DT Managed Workshop Activegate"
    )
  )}"
}
