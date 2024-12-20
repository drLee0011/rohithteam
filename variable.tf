variable "public_key" {
 description = "SSH Public key"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"  # Change this if needed to match your region
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
  default     = "ami-08eb150f611ca277f"  # Ensure this AMI ID is for your region
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
   default    ="subnet-0a58195b9bb1bdb40" 
}
