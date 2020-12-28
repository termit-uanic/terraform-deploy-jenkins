###############################################################
# Data for assign role
###############################################################
data "aws_iam_policy_document" "role_assume_policy" {
  count = (var.create_s3_bucket || var.create_efs_drive) ? 1 : 0

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
# create role for access EC2 to s3 bucket and SSM
###############################################################
resource "aws_iam_role" "access_role_for_jenkins" {
  count = (var.create_s3_bucket || var.create_efs_drive) ? 1 : 0

  name               = "access_role_for_jenkins"
  assume_role_policy = data.aws_iam_policy_document.role_assume_policy[0].json

  tags = {
    Name        = var.jenkins_name
    Environment = var.tag_enviroment
  }
}

###############################################################
# create access policy to S3
###############################################################
resource "aws_iam_policy" "s3_access_policy" {
  count = var.create_s3_bucket ? 1 : 0

  name        = "s3_policy_to_jenkins_bucket"
  path        = "/"
  description = "Write access to s3 bucket"

  policy = templatefile("${path.module}/templates/s3_policy.json.tpl", { name_bucket = aws_s3_bucket.jenkins_backup[0].bucket })
}

###############################################################
# create access policy to SSM
###############################################################
resource "aws_iam_policy" "ssm_access_policy" {
  count = var.create_efs_drive ? 1 : 0

  name        = "ssm_policy_to_jenkins_data"
  path        = "/"
  description = "Manage EC2 host via SSM"

  policy = templatefile("${path.module}/templates/ssm_policy.json.tpl", {})
}

###############################################################
# attach policy S3 to role
###############################################################
resource "aws_iam_role_policy_attachment" "attach_s3" {
  count = var.create_s3_bucket ? 1 : 0

  role       = aws_iam_role.access_role_for_jenkins[0].name
  policy_arn = aws_iam_policy.s3_access_policy[0].arn
}

###############################################################
# attach policy SMM to role
###############################################################
resource "aws_iam_role_policy_attachment" "attach_ssm" {
  count = var.create_efs_drive ? 1 : 0

  role       = aws_iam_role.access_role_for_jenkins[0].name
  policy_arn = aws_iam_policy.ssm_access_policy[0].arn
}

###############################################################
# create profile for access to s3 bucket
###############################################################
resource "aws_iam_instance_profile" "jenkins_access_profile" {
  count = (var.create_s3_bucket || var.create_efs_drive) ? 1 : 0

  name = "access_profile_to_jenkins"
  role = aws_iam_role.access_role_for_jenkins[0].name
}
