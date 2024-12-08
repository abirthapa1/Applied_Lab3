terraform {
  required_providers {
    aws = {
        version = "~> 3.44.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "aws" {
  region = var.region
}

#deploying networking resources
module "vpc" {
  source = "./modules/vpc"
}

#deploying our EC2 instances
module "compute" {
  source            = "./modules/compute"
  subnets           = module.vpc.public_subnets
  security_group    = module.vpc.public_sg
  subnet_ips        = module.vpc.subnet_ips
}