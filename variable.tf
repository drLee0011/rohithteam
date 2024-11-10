variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1" # Ireland region
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
  default     = "ami-08eb150f611ca277f" # Amazon Linux 2 AMI ID for eu-west-1
}

# variable "key_pair_name" {
#   description = "Name of the key pair for SSH access"
#   type        = string
#   default     = "terraform"
# }