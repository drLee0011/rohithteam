# main.tf

# Fetching the existing VPC by its ID
data "aws_vpc" "main" {
  id = "vpc-0fbaa0fc156ca7a9d"  # The VPC ID you provided
}

# Create a public subnet in the VPC (Availability Zone: eu-north-1b)
resource "aws_subnet" "public_subnet" {
  vpc_id                  = data.aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"  # Change to your desired subnet CIDR block
  availability_zone       = "eu-north-1b"  # Specify the Availability Zone
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnet"
  }
}

# Create an Internet Gateway for the VPC
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = data.aws_vpc.main.id
}

# Create a Route Table Association (to connect the subnet with the Internet Gateway)
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = "rtb-048fa34f28c9cca8c"  # Replace with your actual route table ID
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
  ami                    = var.ami_id  # This uses the AMI ID variable defined in variables.tf
  instance_type          = "t3.micro"  # Instance type as per your configuration
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = var.key_pair_name  # This uses the key pair name defined in variables.tf
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
