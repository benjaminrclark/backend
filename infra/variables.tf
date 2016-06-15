variable "environment" {
   description = "Name of this environment"
   default = "production"
}

variable "aws_access_key" {
    description = "Access key for AWS"
}

variable "aws_secret_key" {
    description = "Secret key for AWS"
}

variable "aws_region" {
    description = "Region where we will operate."
    default = "eu-west-1"
}

variable "remote_state_bucket" {
    description = "S3 Bucket for the shared remote state."
}

variable "remote_state_folder" {
    description = "S3 folder for the shared remote state."
}

