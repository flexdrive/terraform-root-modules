module "f1-santander" {
  source           = "ns"
  accounts_enabled = "${var.accounts_enabled}"
  namespace        = "${var.namespace}"
  stage            = "f1-santander"
  zone_id          = "${aws_route53_zone.parent_dns_zone.zone_id}"
  resource_region  = "eu-central-1"
}

output "f1-santander_name_servers" {
  value = "${module.f1-santander.name_servers}"
}
