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

variable "key_pair_name" {
  description = "Name of the key pair for SSH access"
  type        = string
  default     = "finalkey"  # Replace with your key pair name
}
