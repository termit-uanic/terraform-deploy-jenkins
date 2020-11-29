variable "company_name" {
  description = "The name of company"
  default     = "termit"
}

variable "region" {
  description = "The AWS region to create resources in"
  default     = "eu-central-1"
}

variable "availability_zone" {
  description = "The key availability zone in region"
  default     = "b"
}

variable "ami_owners" {
  description = "The owners of ami images for search"
  default     = ["099720109477"] # Canonical
}

variable "ami_search_strings" {
  description = "The array of search strings as part name of image"
  default     = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-*"]
}

variable "ami_arch" {
  description = "The architecture for image"
  default     = ["x86_64"]
}

variable "tag_enviroment" {
  description = "The value tag enviroment"
  default     = "production"
}

variable "jenkins_name" {
  description = "The name of the Jenkins server"
  default     = "jenkins"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "Kind of type instance"
}

variable "cidr_block" {
  default     = "192.168.1.0/24"
  description = "The CIDR block for vpc and subnet"
}

variable "key_name" {
  default     = "jenkins"
  description = "SSH key name in your AWS account for AWS instances"
}
