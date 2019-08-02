module "f1-shft" {
  source           = "ns"
  accounts_enabled = "${var.accounts_enabled}"
  namespace        = "${var.namespace}"
  stage            = "f1-shft"
  zone_id          = "${aws_route53_zone.parent_dns_zone.zone_id}"
}

output "f1-shft_name_servers" {
  value = "${module.f1-shft.name_servers}"
}
