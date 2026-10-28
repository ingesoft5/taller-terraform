terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Provider configurado para emulación local con LocalStack (puerto 4566)
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    ec2 = "http://localhost:4566"
    s3  = "http://localhost:4566"
    iam = "http://localhost:4566"
  }
}

resource "aws_vpc" "lab_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "terraform-lab-vpc" }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = { Name = "terraform-public-subnet" }
}

resource "aws_s3_bucket" "state_storage" {
  bucket = "icesi-tfstate-storage-2026"
  tags   = { Environment = "Laboratory-205M" }
}

output "vpc_id" {
  value = aws_vpc.lab_vpc.id
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.state_storage.arn
}
