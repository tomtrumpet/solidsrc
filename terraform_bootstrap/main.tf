provider "aws" {
 region = "${var.region}"
}

resource "aws_s3_bucket" "terraform" {
  bucket = "${var.state_bucket}"

  tags {
    Name        = "${var.state_bucket}"
    Environment = "${var.env}"
  }

  versioning {
    enabled = true
  }
}

resource "aws_dynamodb_table" "terraform" {
  name           = "${var.dynamodb_table}"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
