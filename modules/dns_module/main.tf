# Getting the zone ID of martinhristov.xyz zone . 
data "aws_route53_zone" "marti_zone" {
  name = var.zone_name
}

# Putting an A record to reach OpenVPN server at marti.martinhristov.xyz
resource "aws_route53_record" "openvpn_record" {
  zone_id = data.aws_route53_zone.marti_zone.zone_id
  name    = "marti.${data.aws_route53_zone.marti_zone.name}"
  type    = "A"
  ttl     = "300"
  records = ["${var.public_ip}"]
}



