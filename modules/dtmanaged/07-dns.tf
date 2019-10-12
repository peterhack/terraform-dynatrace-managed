//  Notes: We could make the internal domain a variable, but not sure it is
//  really necessary.

//  Create the internal DNS.
resource "aws_route53_zone" "internal" {
  name = "dtmanaged.local"
  comment = "DT Managed Workshop Cluster Internal DNS"
  vpc {
    vpc_id = "${aws_vpc.dtmanaged.id}"
  }
  tags = {
    Name    = "DT Managed Workshop Internal DNS"
    Project = "dtmanaged"
  }
}

//  Routes for 'master'.
resource "aws_route53_record" "master-a-record" {
    zone_id = "${aws_route53_zone.internal.zone_id}"
    name = "master.dtmanaged.local"
    type = "A"
    ttl  = 300
    records = [
        "${aws_instance.dtmanaged.private_ip}"
    ]
}
