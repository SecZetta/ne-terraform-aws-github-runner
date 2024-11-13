# Input variable definitions
variable "customer" {
  description = "Name of the customer."
  type        = string
}

variable "common_tags" {
  description = "common tags from local.tf"
  type      = map
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC we will be granting access to with this association."
  type        = string
}

variable "public_cidrs" {
  description = "Public subnet CIDR blocks and AZ mappings"
  type        = map(string)
}

variable "igw_name" {
  description = "Name of the Internet Gateway to use in this VPC"
  type        = string
}

variable "public_rt_name" {
  description = "Name of the Public Route table to use in this VPC"
  type        = string
}

variable "region" {
  description = "VPC Region"
  type        = string
}

variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
}

