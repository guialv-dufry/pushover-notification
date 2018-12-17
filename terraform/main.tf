terraform {
  backend "s3" {
    bucket         = "terraform.thebrightons.co.uk"
    key            = "pushover-notification/state"
    region         = "eu-west-1"
    dynamodb_table = "TerraformStateLocks"
  }
}

provider "aws" {
  version    = "~> 1.52"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "us-east-1"
}

provider "aws" {
  alias  = "ew1"
  region = "eu-west-1"
}

provider "aws" {
  alias  = "ew2"
  region = "eu-west-2"
}

module "deploy_ue1" {
  source                     = "./pushover_notification"
  sns_access_account_ids     = ["${var.skylab_account_id}"]
  deployment_package         = "${var.deployment_package}"
  publish_function           = "${var.publish_function}"
  default_pushover_app_token = "${var.default_pushover_app_token}"
  default_pushover_user_key  = "${var.default_pushover_user_key}"
}

module "deploy_ew1" {
  source                     = "./pushover_notification"
  sns_access_account_ids     = ["${var.skylab_account_id}"]
  deployment_package         = "${var.deployment_package}"
  publish_function           = "${var.publish_function}"
  default_pushover_app_token = "${var.default_pushover_app_token}"
  default_pushover_user_key  = "${var.default_pushover_user_key}"

  providers = {
    aws = "aws.ew1"
  }
}

module "deploy_ew2" {
  source                     = "./pushover_notification"
  sns_access_account_ids     = ["${var.skylab_account_id}"]
  deployment_package         = "${var.deployment_package}"
  publish_function           = "${var.publish_function}"
  default_pushover_app_token = "${var.default_pushover_app_token}"
  default_pushover_user_key  = "${var.default_pushover_user_key}"

  providers = {
    aws = "aws.ew2"
  }
}
