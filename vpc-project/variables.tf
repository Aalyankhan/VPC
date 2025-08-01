variable "aws_region" {
  description = "The AWS region to deploy resources"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "The CIDR block for the public subnet"
  default     = ["10.0.1.0/24" , "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "The CIDR block for the private subnet"
  default     = ["10.0.101.0/24" , "10.0.102.0/24"]
}

variable "bastion_ami" {
  description = "The AMI ID for the bastion host"
  default     = "ami-0c55b159cbfafe1f0"
}

variable "bastion_instance_type" {
  description = "The instance type for the bastion host"
  default     = "t2.micro"
}
