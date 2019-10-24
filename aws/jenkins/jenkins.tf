variable "max_availability_zones" {
  default = "2"
}
# variable "tags" {
#   type        = "map"
#   default     = {
#     Platform     = "Jenkins Docker"
#     Lifecycle    = "Dev"
#   }
#   description = "Additional tags"
# }

# locals {
#   tags = "${merge(var.tags, map("Purpose", "Devops"))}"
# }

data "aws_availability_zones" "available" {}

# module "acm_cert" {
#   source                            = "git::https://github.com/cloudposse/terraform-aws-acm-request-certificate.git?ref=0.11/master"
#   domain_name                       = "garage.flexdriveplatforms.com"
#   process_domain_validation_options = true
#   ttl                               = "300"
#   subject_alternative_names         = ["*.garage.flexdriveplatforms.com"]
# }

module "jenkins" {
  source      = "git::https://github.com/cloudposse/terraform-aws-jenkins.git?ref=0.11/master"
  namespace   = "garage"
  name        = "builds"
  stage       = "dev1"
  description = "Jenkins server as Docker container running on Elastic Beanstalk"

  master_instance_type         = "t2.medium"
  aws_account_id               = "978904061259"
  aws_region                   = "us-west-2"
  availability_zones           = ["${slice(data.aws_availability_zones.available.names, 0, var.max_availability_zones)}"]
  vpc_id                       = "${module.vpc.vpc_id}"
  zone_id                      = "Z2BWKHP4YKSTQZ"
  public_subnets               = "${module.subnets.public_subnet_ids}"
  private_subnets              = "${module.subnets.private_subnet_ids}"
  loadbalancer_certificate_arn = "${module.certificate.arn}"
  ssh_key_pair                 = "fd-devops"
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.17.0 running Multi-container Docker 18.06.1-ce (Generic)"

  github_oauth_token  = ""
  github_organization = "cloudposse"
  github_repo_name    = "jenkins"
  github_branch       = "master"

  datapipeline_config = {
    instance_type = "t2.medium"
    email         = "hasan.soneji@flexdrive.com"
    period        = "12 hours"
    timeout       = "60 Minutes"
  }

  env_vars = {
    JENKINS_USER          = "admin"
    JENKINS_PASS          = "temp-pass-123"
    JENKINS_NUM_EXECUTORS = 4
  }

  tags = {
    Purpose      = "Jenkins Docker"
    Lifecycle    = "Dev"
  }
}

module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=0.11/master"
  namespace  = "garage"
  name       = "builds"
  stage      = "dev1"
  cidr_block = "10.0.0.0/16"

  tags = {
    Purpose      = "Jenkins Docker"
    Lifecycle    = "Dev"
  }
}

module "subnets" {
  source              = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=0.11/master"
  availability_zones  = ["${slice(data.aws_availability_zones.available.names, 0, var.max_availability_zones)}"]
  namespace           = "garage"
  name                = "builds"
  stage               = "dev1"
  vpc_id              = "${module.vpc.vpc_id}"
  igw_id              = "${module.vpc.igw_id}"
  cidr_block          = "${module.vpc.vpc_cidr_block}"
  nat_gateway_enabled = "true"

  tags = {
    Purpose      = "Build Pipeline Network"
    Lifecycle    = "Dev"
  }
}
