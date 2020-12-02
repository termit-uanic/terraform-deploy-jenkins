variable "company_name" {
  description = "The name of company"
  type        = "string"
  default     = "termit"
}

variable "region" {
  description = "The AWS region to create resources in"
  type        = "string"
  default     = "eu-central-1"
}

variable "availability_zone" {
  description = "The key availability zone in region"
  type        = "string"
  default     = "b"
}

variable "ami_owners" {
  description = "The owners of ami images for search"
  type        = "string"
  default     = ["099720109477"] # Canonical
}

variable "ami_search_strings" {
  description = "The array of search strings as part name of image"
  type        = "string"
  default     = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-*"]
}

variable "ami_arch" {
  description = "The architecture for image"
  type        = "string"
  default     = ["x86_64"]
}

variable "tag_enviroment" {
  description = "The value tag enviroment"
  type        = "string"
  default     = "production"
}

variable "jenkins_name" {
  description = "The name of the Jenkins server"
  type        = "string"
  default     = "jenkins"
}

variable "instance_type" {
  default     = "t2.micro"
  type        = "string"
  description = "Kind of type instance"
}

variable "cidr_block" {
  default     = "192.168.1.0/24"
  type        = "string"
  description = "The CIDR block for vpc and subnet"
}

variable "key_name" {
  default     = "jenkins"
  type        = "string"
  description = "SSH key name in your AWS account for AWS instances"
}

# Important!
# This variable is not used now. Image Jenkins ignore that.
variable "jenkins_user_name" {
  default     = "admin"
  type        = "string"
  description = "The user name in Jenkins"
}

# Important!
# This variable is not used now. Image Jenkins ignore that.
variable "jenkins_user_password" {
  default     = "PaSsw0rD"
  type        = "string"
  description = "The user password in Jenkins"
}
