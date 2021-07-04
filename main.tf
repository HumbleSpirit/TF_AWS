terraform {
	backend "s3" {
    bucket = "terraform-state-sb"
    key = "terraform/terraform.tfstate"
    region = "eu-central-1"
	dynamodb_table = "terraform-lock"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.47"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "devops"
  #profile does not working when calling from S3 backend configuration. Use  AWS_PROFILE=profile_name terraform apply (plan init)
  region  = "eu-central-1"
}

resource "aws_instance" "Jenkins_Server" {
  ami           = "ami-089b5384aac360007"
  instance_type = "t2.micro"
}
resource "aws_s3_bucket" "bucket" {
  bucket = "terraform-state-sb"
}
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "terraform-lock"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
attribute {
    name = "LockID"
    type = "S"
  }
}