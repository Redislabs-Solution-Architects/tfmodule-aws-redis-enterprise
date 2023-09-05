##########################################################################
locals {
  cluster-prefix      = var.cluster-prefix
  zone-name           = var.zone-name
  node-external-ips   = aws_eip.re-eip[*].public_ip

  re-security-group   = aws_security_group.re[*].id

}
##########################################################################
data "aws_route53_zone" "zone" {
  name         = local.zone-name
  private_zone = false # This cannot be used with a private zone
}
resource "aws_route53_record" "glue" {
  count   = length(local.node-external-ips)
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "ns${count.index + 1}.${local.cluster-prefix}.${local.zone-name}."
  type    = "A"
  ttl     = "300"
  records = [element(local.node-external-ips, count.index)]
}

resource "aws_route53_record" "ns" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "${local.cluster-prefix}.${local.zone-name}"
  type    = "NS"
  ttl     = "300"
  records = formatlist("ns%s.${local.cluster-prefix}.${local.zone-name}", range(1, length(local.node-external-ips) + 1))
}

##########################################################################
