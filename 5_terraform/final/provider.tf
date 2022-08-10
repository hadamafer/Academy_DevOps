terraform {
  #required_version = ">= 1.0.6"
  required_version = ">= 1.1.9"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.12.1"
    }
  }
}
provider "aws" {
  profile = "default"
  
  default_tags {
    tags = {
      env            = "ac-aws",
      "cost:env"     = "academy-aws",
      "cost:project" = "ac-aws-pract"
    }
  }
}