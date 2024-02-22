terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.30.0"
    }
  }

  #adding s3 bucket for remote state storage
  backend "s3"{
    bucket = "test-tf-statefiles-bucket"
    key = "terraform.tfstate"
    region = "ap-south-1"
  }
}

provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source = "./modules/vpc"
  vpc_name = "test"
  cidr_block = "10.0.0.0/16"
  project_name_env = "test"
  public1_subnet_cidr = "10.0.1.0/24"
  public2_subnet_cidr = "10.0.2.0/24"
  private1_subnet_cidr = "10.0.3.0/24"
  private2_subnet_cidr = "10.0.4.0/24"
}

module "rds" {
  source = "./modules/RDS"
  subnet_ids = [module.vpc.private1_subnet_id, module.vpc.private2_subnet_id]
  engine = "MySQL"
  storage = "10"
  storage_type = "gp2"
  region = "ap-south-1"
  final_snapshot_identifier = "test-db"
  identifier = "test-db"
  username = "admin"
  password = "test12345678"
  instance_class = "db.t3.small"
}

module "ec2_instance" {
  source = "./modules/ec2"
  instance_name = "test-server"
  key_name = "test"
  subnet_ids = module.vpc.public1_subnet_id
  ami_id = "ami-0449c34f967dbf18a"
  region = "ap-south-1"
  instance_type = "t3.xlarge"
}

module "alb" {
  source = "./modules/ALB"
  vpc_id = module.vpc.vpc_id
  public1_subnet = module.vpc.public1_subnet_id
  public2_subnet = module.vpc.public2_subnet_id
}
