provider "aws" {
  region = var.region
}

module "deploy_jenkins" {
  source = "../../"

  region            = "eu-central-1"
  availability_zone = "c"
  instance_type     = "t2.micro"
  key_name          = "jenkins"
  create_s3_bucket  = true
}
