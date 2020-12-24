provider "aws" {
  region = var.region
}

module "deploy_jenkins" {
  source = "../../"

  # The owner image
  # 099720109477 # Canonical
  # 459993507469 - Amazon
  ami_owners = ["137112412989"]

  # The name image
  # "amzn2-ami-hvm-2.0.*.0-x86_64-gp2" # Amazon linux
  # "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-*" # Canonical ubuntu 20.04
  ami_search_strings = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]


  region            = "eu-central-1"
  availability_zone = "c"
  instance_type     = "t2.micro"
  key_name          = "jenkins"
  create_s3_bucket  = false
  create_efs_drive  = true
}
