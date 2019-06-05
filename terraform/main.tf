provider "aws" {
 region = "eu-west-2"
}

terraform {
  backend "s3" {
    bucket = "solidsrc-website-state"
    key    = "terraform.tfstate"
    region = "eu-west-2"
    dynamodb_table = "solidsrc-lock"
  }
}

data "aws_route53_zone" "selected" {
  name = "${var.domain}."
}

module "website" {
  source    = "git::https://github.com/cloudposse/terraform-aws-s3-website.git?ref=master"
  namespace = "solidsrc"
  stage     = "prod"
  name      = "web"
  hostname  = "www.${var.domain}"
  parent_zone_id = "${data.aws_route53_zone.selected.zone_id}"
}
