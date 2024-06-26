terraform {
  backend "s3" {
    bucket = "bjjjjjj"
    key    = "TFstate/state"
    region = "us-east-2"
    dynamodb_table = "MyTable"
    insecure = true
  }
   required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
}
   }
}



# Configure the AWS Provider
provider "aws" {
  region   = "us-east-2"
  insecure = true
}