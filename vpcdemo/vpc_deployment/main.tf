provider "aws" {
  region = "us-east-2"
}

terraform {
  backend "local" {}
}

module "vpc" {
  source = "./module"

  vpc_cidr = "10.0.0.0/16"
  vpc_name = "example-vpc"
  
  vpc_tags = {
    Environment = "Development"
    Project     = "Example"
  }
  
  common_tags = {
    ManagedBy = "Terraform"
    Owner     = "Infrastructure Team"
  }
  
  subnets = {
    public-subnet-1 = {
      attach_to_tgw = true
      cidr_block              = "10.0.1.0/24"
      availability_zone       = "us-east-2a"
      public                  = true
      map_public_ip_on_launch = false
      tags = {
        Type = "Public"
        Tier = "Web"
      }
    },
    public-subnet-2 = {
      attach_to_tgw = true
      cidr_block              = "10.0.2.0/24"
      availability_zone       = "us-east-2b"
      public                  = true
      map_public_ip_on_launch = false
      tags = {
        Type = "Public"
        Tier = "Web"
      }
    },
    private-subnet-1 = {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "us-east-2a"
      tags = {
        Type = "Private"
        Tier = "Application"
      }
    },
    private-subnet-2 = {
      cidr_block        = "10.0.4.0/24"
      availability_zone = "us-east-2b"
      tags = {
        Type = "Private"
        Tier = "Application"
      }
    },
    database-subnet-1 = {
      cidr_block        = "10.0.5.0/24"
      availability_zone = "us-east-2a"
      tags = {
        Type = "Private"
        Tier = "Database"
      }
    },
    database-subnet-2 = {
      cidr_block        = "10.0.6.0/24"
      availability_zone = "us-east-2b"
      tags = {
        Type = "Private"
        Tier = "Database"
      }
    }
  }

  create_transit_gateway_attachment = true
  transit_gateway_id                = "tgw-040c1d9a2d68d1114"
  transit_gateway_attachment_name   = "example-vpc-tgw-attachment"
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_ids" {
  value = module.vpc.subnet_ids
}

output "transit_gateway_attachment_id" {
  description = "The ID of the Transit Gateway Attachment"
  value       = module.vpc.transit_gateway_attachment_id
}