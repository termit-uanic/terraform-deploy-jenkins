terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

###############################################################
# set provider and region
###############################################################
provider "aws" {
  region = var.region
}

###############################################################
# data selected region
###############################################################
data "aws_region" "current" {}

###############################################################
# data current account
###############################################################
data "aws_caller_identity" "current" {}

###############################################################
# look up ami image in region
###############################################################
data "aws_ami" "ami_latest" {
  owners      = var.ami_owners
  most_recent = true
  filter {
    name   = "name"
    values = var.ami_search_strings
  }
  filter {
    name   = "architecture"
    values = var.ami_arch
  }
}

###############################################################
# create s3 backet for jenkins backup
# name must be without dot - for able to mount in EC2 as drive
###############################################################
resource "aws_s3_bucket" "jenkins_backup" {
  count = var.create_s3_bucket ? 1 : 0

  bucket = "${var.company_name}--jenkins-backup--${var.region}--${data.aws_caller_identity.current.account_id}"
  acl    = "private"

  versioning {
    enabled = false
  }

  tags = {
    Name        = var.jenkins_name
    Environment = var.tag_enviroment
  }
}

###############################################################
# Data for assign role
###############################################################
data "aws_iam_policy_document" "role_assume_policy" {
  count = var.create_s3_bucket ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

###############################################################
# create role for access to s3 bucket
###############################################################
resource "aws_iam_role" "s3_access_role" {
  count = var.create_s3_bucket ? 1 : 0

  name               = "s3_access_role_to_jenkins_bucket"
  assume_role_policy = data.aws_iam_policy_document.role_assume_policy[0].json

  tags = {
    Name        = var.jenkins_name
    Environment = var.tag_enviroment
  }
}

###############################################################
# create access policy
###############################################################
resource "aws_iam_policy" "s3_access_policy" {
  count = var.create_s3_bucket ? 1 : 0

  name        = "s3_policy_to_jenkins_bucket"
  path        = "/"
  description = "Write access to s3 bucket"

  policy = templatefile("${path.module}/templates/s3_policy.json.tpl", { name_bucket = aws_s3_bucket.jenkins_backup[0].bucket })
}

###############################################################
# attach policy to role
###############################################################
resource "aws_iam_role_policy_attachment" "attach" {
  count = var.create_s3_bucket ? 1 : 0

  role       = aws_iam_role.s3_access_role[0].name
  policy_arn = aws_iam_policy.s3_access_policy[0].arn
}

###############################################################
# create profile for access to s3 bucket
###############################################################
resource "aws_iam_instance_profile" "s3_access_profile" {
  count = var.create_s3_bucket ? 1 : 0

  name = "s3_access_profile_to_jenkins_bucket"
  role = aws_iam_role.s3_access_role[0].name
}

###############################################################
# create vpc
###############################################################
resource "aws_vpc" "jenkins_vpc" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name        = var.jenkins_name
    Environment = var.tag_enviroment
  }
}

###############################################################
# create subnet
###############################################################
resource "aws_subnet" "jenkins_subnet" {
  vpc_id                  = aws_vpc.jenkins_vpc.id
  availability_zone       = "${var.region}${var.availability_zone}"
  cidr_block              = var.cidr_block
  map_public_ip_on_launch = true

  tags = {
    Name        = var.jenkins_name
    Environment = var.tag_enviroment
  }
}

###############################################################
# create gateway
###############################################################
resource "aws_internet_gateway" "jenkins_gateway" {
  vpc_id = aws_vpc.jenkins_vpc.id

  tags = {
    Name        = var.jenkins_name
    Environment = var.tag_enviroment
  }
}

###############################################################
# route table: adding route and tags
###############################################################
resource "aws_default_route_table" "main_route_table" {
  default_route_table_id = aws_vpc.jenkins_vpc.main_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jenkins_gateway.id
  }

  tags = {
    Name        = var.jenkins_name
    Environment = var.tag_enviroment
  }
}

###############################################################
# create security group
###############################################################
resource "aws_security_group" "sg_jenkins" {
  name        = "sg_${var.jenkins_name}"
  description = "Allows all traffic"
  vpc_id      = aws_vpc.jenkins_vpc.id

  # SSH
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  # HTTP
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  # Jenkins JNLP port
  ingress {
    from_port = 50000
    to_port   = 50000
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  tags = {
    Name        = var.jenkins_name
    Environment = var.tag_enviroment
  }
}

###############################################################
# create ec2 instance
###############################################################
resource "aws_instance" "jenkins" {
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg_jenkins.id] # for not default VPC we need use vpc_security_group_ids instead security_groups
  ami                    = data.aws_ami.ami_latest.id
  key_name               = var.key_name
  user_data              = templatefile("${path.module}/templates/user_data.sh.tpl", { JENKINS_USER_NAME = var.jenkins_user_name, JENKINS_USER_PASSWORD = var.jenkins_user_password })
  iam_instance_profile   = var.create_s3_bucket ? aws_iam_instance_profile.s3_access_profile[0].name : null
  availability_zone      = "${var.region}${var.availability_zone}"
  subnet_id              = aws_subnet.jenkins_subnet.id

  tags = {
    Name        = var.jenkins_name
    Environment = var.tag_enviroment
  }
}
