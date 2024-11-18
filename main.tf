# Retrieve the existing VPC
data "aws_vpc" "main" {
  id = "vpc-0ee304c59e546ce25"  # Replace with your actual VPC ID
}

# Public Subnet in the VPC
resource "aws_subnet" "public_subnet" {
  vpc_id                  = data.aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"  # Adjusted to avoid conflict
  availability_zone       = "eu-north-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnet"
  }
}

# Security Group allowing HTTP, HTTPS, and SSH
resource "aws_security_group" "allow_http_https_ssh" {
  vpc_id = data.aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "AllowHTTPSSHTraffic"
  }
}

# Launch EC2 instance in Public Subnet
resource "aws_instance" "newone" {
  ami           = var.ami_id  # This uses the AMI ID variable defined in variables.tf
  instance_type = "t3.micro"  # Instance type as per your configuration
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = var.key_pair_name  # This uses the key pair name defined in variables.tf
  vpc_security_group_ids = [aws_security_group.allow_http_https_ssh.id]

  tags = {
    Name = "CA_1"  # Instance name based on your EC2 details
  }

  # Monitoring
  monitoring = false

  # Instance Metadata Service v2 (IMDSv2) requirement
  metadata_options {
    http_tokens = "required"
  }

  # Correctly set availability zone here
  availability_zone = "eu-north-1b"  # Set as per your instance availability zone
}
