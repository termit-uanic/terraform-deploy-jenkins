variable "company_name" {
  description = "The name of company"
  type        = string
  default     = "mycompany"
}

variable "region" {
  description = "The AWS region to create resources in"
  type        = string
  default     = "eu-central-1"
}

variable "availability_zone" {
  description = "The key availability zone in region"
  type        = string
  default     = "b"
}

# If you use efs remember: EFS support
# - Amazon Linux 2
# - Amazon Linux
# - Debian version 9 and newer
# - Fedora version 28 and newer
# - Red Hat Enterprise Linux (and derivatives such as CentOS) version 7 and newer
# - Ubuntu 16.04 LTS and newer

variable "ami_owners" {
  description = "The owners of ami images for search"
  type        = list(any)
  default     = ["099720109477"] # Canonical
  # 137112412989 - Amazon
}

variable "ami_search_strings" {
  description = "The array of search strings as part name of image"
  type        = list(any)
  default     = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-*"] # Canonical ubuntu 20.04
  # amzn2-ami-hvm-2.0.*-x86_64-gp2 - Amazon linux
}

variable "ami_arch" {
  description = "The architecture for image"
  type        = list(any)
  default     = ["x86_64"]
}

variable "tag_enviroment" {
  description = "The value tag enviroment"
  type        = string
  default     = "production"
}

variable "jenkins_name" {
  description = "The name of the Jenkins server"
  type        = string
  default     = "jenkins"
}

variable "instance_type" {
  description = "Kind of type instance"
  type        = string
  default     = "t2.micro"
}

variable "cidr_block" {
  description = "The CIDR block for vpc and subnet"
  type        = string
  default     = "192.168.1.0/24"
}

variable "key_name" {
  description = "SSH key name in your AWS account for AWS instances"
  type        = string
  default     = "jenkins"
}

variable "create_s3_bucket" {
  description = "Create S3 bucket for backup"
  type        = bool
  default     = true
}

variable "create_efs_drive" {
  description = "Create EFS partition for Jenkins data"
  type        = bool
  default     = true
}

# Important!
# This variable is not used now. Image Jenkins ignore that.
variable "jenkins_user_name" {
  description = "The user name in Jenkins"
  type        = string
  default     = "admin"
}

# Important!
# This variable is not used now. Image Jenkins ignore that.
variable "jenkins_user_password" {
  description = "The user password in Jenkins"
  type        = string
  default     = "PaSsw0rD"
}
