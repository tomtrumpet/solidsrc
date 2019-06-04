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

module "website" {
  source    = "git::https://github.com/cloudposse/terraform-aws-s3-website.git?ref=master"
  namespace = "solidsrc"
  stage     = "prod"
  name      = "web"
  hostname  = "www.solidsrc.co.uk"
}
