variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "main-vpc"
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}

variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

variable "subnets" {
  description = "Map of subnet configurations with individual CIDR blocks and tags"
  type = map(object({
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = optional(bool, false)
    public                  = optional(bool, false)
    attach_to_tgw           = optional(bool, false)
    tags                    = map(string)
  }))
  default = {}
}

variable "create_transit_gateway_attachment" {
  description = "Whether to create a Transit Gateway attachment"
  type        = bool
  default     = false
}

variable "transit_gateway_id" {
  description = "ID of the Transit Gateway to attach to"
  type        = string
  default     = ""
}

variable "transit_gateway_attachment_name" {
  description = "Name of the Transit Gateway attachment"
  type        = string
  default     = ""
}