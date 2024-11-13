# Output variable definitions
output "vpc_id" {
    value = aws_vpc.main.id
    description = "The id of the VPC created in this module"
}

output "vpc_cidr" {
    value = aws_vpc.main.cidr_block
    description = "CIDR Block from VPC created in this module"
}

output "public_subnets" {
    value = [
        for subnet in aws_subnet.public_subnets: subnet.id
    ]
    description = "The list of public subnet ids created in this module"
}

output "public_cidrs" {
    value = [
        for subnet in aws_subnet.public_subnets: subnet.cidr_block
    ]
    description = "The list of public subnet cidr_blocks created in this module"
}
