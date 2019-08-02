module "f1-lyft" {
  source           = "ns"
  accounts_enabled = "${var.accounts_enabled}"
  namespace        = "${var.namespace}"
  stage            = "f1-lyft"
  zone_id          = "${aws_route53_zone.parent_dns_zone.zone_id}"
}

output "f1-lyft_name_servers" {
  value = "${module.f1-lyft.name_servers}"
}
