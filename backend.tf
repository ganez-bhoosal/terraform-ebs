terraform {
  backend "s3" {
    bucket = "terraform-ganesh123"
    key    = "terraform/dev/ebs"
    region = "us-east-1"
    profile = "ganesh"
  }
}
