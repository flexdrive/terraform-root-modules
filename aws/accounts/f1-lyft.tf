module "f1-lyft" {
  source                             = "stage"
  namespace                          = "${var.namespace}"
  stage                              = "f1-lyft"
  accounts_enabled                   = "${var.accounts_enabled}"
  account_email                      = "${var.account_email}"
  account_iam_user_access_to_billing = "${var.account_iam_user_access_to_billing}"
  account_role_name                  = "${var.account_role_name}"
}

output "f1-lyft_account_arn" {
  value = "${module.f1-lyft.account_arn}"
}

output "f1-lyft_account_id" {
  value = "${module.f1-lyft.account_id}"
}

output "f1-lyft_organization_account_access_role" {
  value = "${module.f1-lyft.organization_account_access_role}"
}
