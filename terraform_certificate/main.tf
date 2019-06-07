provider "aws" {
 region = "us-east-1"
}

module "acm_request_certificate" {
  source                    = "git::https://github.com/cloudposse/terraform-aws-acm-request-certificate.git?ref=0.1.3"
  domain_name               = "${var.domain}"
  subject_alternative_names = ["*.${var.domain}"]
}
