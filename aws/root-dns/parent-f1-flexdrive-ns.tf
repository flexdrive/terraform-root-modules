module "f1-flexdrive" {
  source           = "ns"
  accounts_enabled = "${var.accounts_enabled}"
  namespace        = "${var.namespace}"
  stage            = "f1-flexdrive"
  zone_id          = "${aws_route53_zone.parent_dns_zone.zone_id}"
}

output "f1-flexdrive_name_servers" {
  value = "${module.f1-flexdrive.name_servers}"
}
