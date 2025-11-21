terraform {
  backend "s3" {
    region = "us-east-1"
    key = "terraform.tfstate"
    bucket = "jellobucketbb4e3f"
  }
}