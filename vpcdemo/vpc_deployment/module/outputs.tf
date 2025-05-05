output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.main.arn
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "subnet_ids" {
  description = "Map of subnet names to their IDs"
  value       = { for k, v in aws_subnet.subnets : k => v.id }
}

output "subnet_arns" {
  description = "Map of subnet names to their ARNs"
  value       = { for k, v in aws_subnet.subnets : k => v.arn }
}

output "subnet_cidr_blocks" {
  description = "Map of subnet names to their CIDR blocks"
  value       = { for k, v in aws_subnet.subnets : k => v.cidr_block }
}

output "transit_gateway_attachment_id" {
  description = "The ID of the Transit Gateway Attachment"
  value       = var.create_transit_gateway_attachment ? aws_ec2_transit_gateway_vpc_attachment.tgw_attachment[0].id : null
}

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = var.create_transit_gateway_attachment ? aws_route_table.public[0].id : null
}