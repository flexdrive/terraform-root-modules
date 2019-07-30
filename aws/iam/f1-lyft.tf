variable "f1-lyft_account_user_names" {
  type        = "list"
  description = "IAM user names to grant access to the `f1-lyft` account"
  default     = []
}

# Provision group access to production account
module "organization_access_group_f1-lyft" {
  source            = "git::https://github.com/cloudposse/terraform-aws-organization-access-group.git?ref=tags/0.4.0"
  enabled           = "${contains(var.accounts_enabled, "f1-lyft") == true ? "true" : "false"}"
  namespace         = "${var.namespace}"
  stage             = "f1-lyft"
  name              = "admin"
  user_names        = "${var.f1-lyft_account_user_names}"
  member_account_id = "${data.terraform_remote_state.accounts.f1-lyft_account_id}"
  require_mfa       = "true"
}

module "organization_access_group_ssm_f1-lyft" {
  source  = "git::https://github.com/cloudposse/terraform-aws-ssm-parameter-store?ref=tags/0.1.5"
  enabled = "${contains(var.accounts_enabled, "f1-lyft") == true ? "true" : "false"}"

  parameter_write = [
    {
      name        = "/${var.namespace}/f1-lyft/admin_group"
      value       = "${module.organization_access_group_f1-lyft.group_name}"
      type        = "String"
      overwrite   = "true"
      description = "IAM admin group name for the 'f1-lyft' account"
    },
  ]
}

output "f1-lyft_switchrole_url" {
  description = "URL to the IAM console to switch to the f1-lyft account organization access role"
  value       = "${module.organization_access_group_f1-lyft.switchrole_url}"
}
