resource "aws_eip" "eip" {
  vpc  = true
  tags = local.tags
}

data "aws_route53_zone" "zone" {
  name = "${var.domain}."
}

resource "aws_route53_record" "record" {
  name = "${var.hostname}.${var.domain}."

  records = [
    aws_eip.eip.public_ip,
  ]

  ttl     = "60"
  type    = "A"
  zone_id = data.aws_route53_zone.zone.id
}
