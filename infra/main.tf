provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "terraform_remote_state" "shared" {
  backend = "s3"
  config {
    bucket  = "${var.remote_state_bucket}-${var.environment}"
    key = "${var.remote_state_folder}/terraform.tfstate"
    region = "${var.aws_region}"
  }
}
