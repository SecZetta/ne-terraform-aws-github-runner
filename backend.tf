### Backend ###
terraform {
  backend "s3" {
    bucket         = "ne-runners-terraform-state"
    key            = "main.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-lock"
    profile        = "internalaccount"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
    random = {
      source = "hashicorp/random"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}

### Providers ###
provider "aws" {
  region     = var.aws_region
  profile                 = var.aws_cli_profile
}

provider "random" {
}


provider "null" {
}
