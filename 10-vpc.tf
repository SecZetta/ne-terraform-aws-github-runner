module "vpc_main" {
  source = "./modules/VPC"

  customer                    = var.customer
  common_tags                 = var.tags
  vpc_cidr                    = var.vpc_cidr
  public_cidrs                = var.public_cidrs
  igw_name                    = var.customer
  public_rt_name              = var.customer
  region                      = var.aws_region
  vpc_name                    = var.vpc_name
}