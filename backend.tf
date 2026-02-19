terraform {
  backend "s3" {
    bucket = "saibucket876"
    key    = "practise/terraform.tfstate"
    region = "us-east-1"
  }
}
