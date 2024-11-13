##########################################
####             VPC
##########################################
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.common_tags,
    {
      "Name" = "${var.vpc_name}-${var.customer}"
    },
  )
}

##########################################
####             SUBNETS
##########################################
resource "aws_subnet" "public_subnets" {
  for_each = var.public_cidrs
    vpc_id                          = aws_vpc.main.id
    cidr_block                      = each.value
    availability_zone               = each.key
    map_public_ip_on_launch         = false
    assign_ipv6_address_on_creation = false

    tags = merge(
      var.common_tags,
      {
        "Name" = "pub-sb-${each.key}"
      },
    )
}

##########################################
####             IGW
##########################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    {
      "Name" = var.igw_name
    },
  )
}

##########################################
####             NAT
##########################################
resource "aws_eip" "eip_nat_gateways" {
  for_each = aws_subnet.public_subnets
    domain = "vpc"

    tags = merge(
      var.common_tags,
      {
        "Name" = "eip-nat-${var.region}-${each.value.availability_zone}"
      },
    )
}

resource "aws_nat_gateway" "nat_gateways" {
  for_each = aws_subnet.public_subnets
  allocation_id = aws_eip.eip_nat_gateways[each.key].id
  subnet_id     = each.value.id

  tags = merge(
    var.common_tags,
    {
      "Name" = "nat-${var.region}-${each.value.availability_zone}"
    },
  )
}

##########################################
####             Routes
##########################################
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    var.common_tags,
    {
      "Name" = var.public_rt_name
    },
  )
}

resource "aws_main_route_table_association" "public" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public_subnets
    subnet_id      = each.value.id
    route_table_id = aws_route_table.public_rt.id
}

#####################Network ACL######################

resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.main.id
  subnet_ids = [for subnet in aws_subnet.public_subnets: subnet.id]

  egress {
    protocol   = "all"
    rule_no    = 900
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  dynamic "ingress" {
    for_each = [for rule_obj in local.nacl_rules : {
      port       = rule_obj.port
      rule_no    = rule_obj.rule_num
      cidr_block = rule_obj.cidr
      action     = rule_obj.action
    }]
    content {
      protocol   = "all"
      rule_no    = ingress.value["rule_no"]
      action     = ingress.value["action"]
      cidr_block = ingress.value["cidr_block"]
      from_port  = ingress.value["port"]
      to_port    = ingress.value["port"]
    }
  }

  tags = merge(
    var.common_tags,
    {
      "Name" = "public subnet network acl"
    },
  )
}

########Setup network ACL rules - block censys########
locals {
  nacl_rules = [
    { port : 0,  rule_num : 900, cidr : "0.0.0.0/0", action: "allow" },
    { port : 0,  rule_num : 101, cidr : "162.142.125.0/24", action: "deny" },
    { port : 0,  rule_num : 102, cidr : "167.94.138.0/24", action: "deny" },
    { port : 0,  rule_num : 103, cidr : "167.94.145.0/24", action: "deny" },
    { port : 0,  rule_num : 104, cidr : "167.94.146.0/24", action: "deny" },
    { port : 0,  rule_num : 105, cidr : "167.248.133.0/24", action: "deny" },
    { port : 0,  rule_num : 106, cidr : "192.35.168.0/23", action: "deny" }
  ]
}