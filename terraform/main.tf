provider "aws" {
  region = "eu-west-2"

  # Make it faster by skipping some checks
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
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

module "cdn" {
  source                   = "./cdn"
  namespace                = "solidsrc"
  stage                    = "prod"
  name                     = "web"
  aliases                  = ["*.${var.domain}", "${var.domain}"]
  parent_zone_id           = "${data.aws_route53_zone.selected.zone_id}"
  use_regional_s3_endpoint = "true"
  origin_force_destroy     = "true"
  cors_allowed_headers     = ["*"]
  cors_allowed_methods     = ["GET", "HEAD", "PUT"]
  cors_allowed_origins     = ["*.${var.domain}"]
  cors_expose_headers      = ["ETag"]
  acm_certificate_arn      = "${var.acm_certificate_arn}"
}

resource "null_resource" "upload_to_s3" {
  provisioner "local-exec" {
    command = "aws s3 sync ${path.module}/../site s3://${module.cdn.s3_bucket_id}"
  }
}
