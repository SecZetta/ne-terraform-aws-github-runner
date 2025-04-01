#data "aws_ssm_parameter" "mongo_public_key" {
#  name         = "/Terraform/mongo_public_key"
#}

#data "aws_ssm_parameter" "mongo_private_key" {
#  name         = "/Terraform/mongo_private_key"
#}

#data "aws_ssm_parameter" "datadog_api_key" {
#  name        = "/Terraform/datadog_api_key"
#}

#data "aws_ssm_parameter" "datadog_app_key" {
#  name        = "/Terraform/datadog_app_key"
#}

#data "aws_ssm_parameter" "cloudflare_api_key" {
#  name        = "/Terraform/cloudflare_api_key"
#}

#data "aws_ssm_parameter" "cloudflare_email" {
#  name        = "/Terraform/cloudflare_email"
#}

### Backend ###
terraform {
  backend "s3" {
    bucket         = "sailpoint-ne-runners-govprod-tf-state"
    key            = "main.tfstate"
    region         = "us-gov-west-1"
    dynamodb_table = "tf-lock"
    profile        = "nerm_fedramp_gov_prod"
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
  profile                   = "nerm_fedramp_gov_prod"
}

provider "random" {
}

#provider "mongodbatlas" {
#  public_key  = data.aws_ssm_parameter.mongo_public_key.value
#  private_key = data.aws_ssm_parameter.mongo_private_key.value
#}

#provider "azuread" {
#}

#provider "datadog" {
#  api_key = data.aws_ssm_parameter.datadog_api_key.value
#  app_key = data.aws_ssm_parameter.datadog_app_key.value
#}

provider "null" {
}

#provider "cloudflare" {
#  email   = data.aws_ssm_parameter.cloudflare_email.value
#  api_key = data.aws_ssm_parameter.cloudflare_api_key.value
#}