terraform {
  backend "s3" {
    bucket         = "andreibakaushyn-terraform-state-bucket"
    key            = "eks-cluster/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "andreibakaushyn-terraform-lock-table"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./vpc-module" # Локальный путь к клонированному модулю VPC

  name             = "andreibakaushyn-eks-vpc"
  cidr             = "10.0.0.0/16"
  azs              = ["us-east-1a", "us-east-1b"]
  public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]
  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Owner       = "andreibakaushyn"
    Environment = "dev"
  }
}

resource "aws_ecr_repository" "repo" {
  name = "andreibakaushyn-eks-repo"
}

module "kms" {
  source = "./kms-module"
  
  create = true
  description = "KMS key for EKS cluster"
  tags = {
    Environment = "dev"
    Owner       = "andreibakaushyn"
  }
}

module "eks" {
  source = "./eks-module" # Локальный путь к модулю EKS

  cluster_name    = "andreibakaushyn-eks-cluster"
  cluster_version = "1.27"

  # Используем корректные переменные из модуля
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 2
      min_capacity     = 1

      instance_type = "t3.micro"
    }
  }
  
}
