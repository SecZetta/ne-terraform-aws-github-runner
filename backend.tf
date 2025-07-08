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
    #mongodbatlas = {
    #  source = "mongodb/mongodbatlas"
    #}
    #azuread = {
    #  source  = "hashicorp/azuread"
    #}
    random = {
      source = "hashicorp/random"
    }
    #datadog = {
    #  source = "DataDog/datadog"
    #}
    null = {
      source = "hashicorp/null"
    }
    #cloudflare = {
    #  source = "cloudflare/cloudflare"
    #  version = "~> 3"
    #}
    #mysql = {
    #  source = "petoju/mysql"
    #}
  }
}

### Providers ###
provider "aws" {
  region     = var.aws_region
  #shared_credentials_files = ["~/.aws/credentials"]
  profile                 = var.aws_cli_profile
}

provider "random" {
}

provider "null" {
}
