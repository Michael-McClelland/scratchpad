/**
 * # AWS VPC Module
 * 
 * This module creates a VPC with customizable subnets.
 * Each subnet has individually defined CIDR blocks and separate parameters for additional tags.
 */

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  
  tags = merge(
    {
      Name = var.vpc_name
    },
    var.vpc_tags
  )
}

resource "aws_subnet" "subnets" {
  for_each = var.subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = lookup(each.value, "map_public_ip_on_launch", false)

  tags = merge(
    {
      Name = each.key
    },
    var.common_tags,
    each.value.tags
  )
}

# Transit Gateway Attachment (optional)
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment" {
  count = var.create_transit_gateway_attachment && var.transit_gateway_id != "" ? 1 : 0
  
  vpc_id             = aws_vpc.main.id
  transit_gateway_id = var.transit_gateway_id
  
  # Only attach subnets that have attach_to_tgw set to true
  subnet_ids = [
    for name, subnet_config in var.subnets : 
    aws_subnet.subnets[name].id 
    if lookup(subnet_config, "attach_to_tgw", false) == true
  ]
  
  tags = merge(
    {
      Name = coalesce(var.transit_gateway_attachment_name, "${var.vpc_name}-tgw-attachment")
    },
    var.vpc_tags
  )
}

# Route Table for public subnets
resource "aws_route_table" "public" {
  count = var.create_transit_gateway_attachment ? 1 : 0
  
  vpc_id = aws_vpc.main.id
  
  tags = merge(
    {
      Name = "${var.vpc_name}-public-rt"
    },
    var.vpc_tags
  )
}

# Route to Transit Gateway
resource "aws_route" "public_transit_gateway" {
  count = var.create_transit_gateway_attachment && var.transit_gateway_id != "" ? 1 : 0
  
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = var.transit_gateway_id
}

# Associate public subnets with the public route table
resource "aws_route_table_association" "public" {
  for_each = var.create_transit_gateway_attachment ? {
    for name, subnet in var.subnets : name => subnet
    if lookup(subnet, "public", false) == true
  } : {}
  
  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = aws_route_table.public[0].id
}