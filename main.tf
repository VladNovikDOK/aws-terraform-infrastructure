provider "aws" {
  region  = "eu-west-2"
  profile = "default"
}
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "terraform-project-vpc"
  }
}
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "terraform-project-public-subnet"
  }
}
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "terraform-project-igw"
  }
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "terraform-project-public-rt"
  }
}
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
resource "aws_security_group" "ec2" {
  name        = "terraform-project-ec2-sg"
  description = "Security group for Terraform project EC2"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "terraform-project-ec2-sg"
  }
}
resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.ec2.id
  cidr_ipv4         = "94.197.98.19/32"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
key_name = aws_key_pair.deployer.key_name
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2.id]

  tags = {
    Name = "terraform-project-ec2"
  }
}
resource "aws_key_pair" "deployer" {
  key_name   = "terraform-project-key"
  public_key = file(pathexpand("~/.ssh/terraform_aws_ec2.pub"))
}
