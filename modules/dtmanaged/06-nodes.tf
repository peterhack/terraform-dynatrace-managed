//  Create an SSH keypair
resource "aws_key_pair" "keypair" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

//  Create the master userdata script.
data "template_file" "setup-master" {
  template = "${file("${path.module}/files/setup-master.sh")}"
  vars = {
    availability_zone = "${data.aws_availability_zones.azs.names[0]}"
  }
}

//  Create the activegate userdata script.
data "template_file" "setup-ag" {
  template = "${file("${path.module}/files/setup-ag.sh")}"
  vars = {
    availability_zone = "${data.aws_availability_zones.azs.names[0]}"
  }
}

// Create Elastic IP for DT Managed master
resource "aws_eip" "dtmanaged_eip" {
  instance = "${aws_instance.dtmanaged.id}"
  vpc      = true
}

//  Launch configuration for the consul cluster auto-scaling group.
resource "aws_instance" "dtmanaged" {
  ami                  = "${data.aws_ami.rhel7_5.id}"
  # Cluster nodes require at least 4cpu and 32GB of memory.
  instance_type        = "t3.2xlarge"
  subnet_id            = "${aws_subnet.public-subnet.id}"
  iam_instance_profile = "${aws_iam_instance_profile.dtmanaged-instance-profile.id}"
  user_data            = "${data.template_file.setup-master.rendered}"

  vpc_security_group_ids = [
    "${aws_security_group.dtmanaged-vpc.id}",
    "${aws_security_group.dtmanaged-public-ingress.id}",
    "${aws_security_group.dtmanaged-public-egress.id}",
  ]

  //  We need at least 30GB for Dynatrace managed, let's be greedy...
  root_block_device {
    volume_size = 200
    volume_type = "gp2"
  }

  key_name = "${aws_key_pair.keypair.key_name}"

  //  Use our common tags and add a specific name.
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "DT Managed Master"
    )
  )}"
}

