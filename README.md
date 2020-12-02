# terraform-deploy-jenkins
Deploying jenkins in AWS

## Before run terraform you must have environment variables
```
$ export AWS_ACCESS_KEY_ID= <your key> # to store and retrieve the remote state in s3.
$ export AWS_SECRET_ACCESS_KEY= <your secret>
$ export AWS_DEFAULT_REGION= <your bucket region e.g. us-west-2>
```

## Key pair
You should be set in `variables.tf` name of ssh key from EC2

## Jenkins user name and passwd
You should be change in `variables.tf` Jenkins user name and password

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.6 |
| aws | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| acceleration\_status | (Optional) Sets the accelerate configuration of an existing bucket. Can be Enabled or Suspended. | `string` | `null` | no |
| acl | (Optional) The canned ACL to apply. Defaults to 'private'. Conflicts with `grant` | `string` | `"private"` | no |

## Outputs

| Name | Description |
|------|-------------|
| this\_s3\_bucket\_arn | The ARN of the bucket. Will be of format arn:aws:s3:::bucketname. |
| this\_s3\_bucket\_bucket\_domain\_name | The bucket domain name. Will be of format bucketname.s3.amazonaws.com. |

## Authors

Module managed by [Yuriy Poltorak](https://github.com/termit-uanic).

## License

BSD Licensed. See LICENSE for full details.

## local run jenkins
It's **only for local** test Docker image
```
docker run -d \
    --restart=always \
    --name jenkins \
    -p 8888:8080 \
    -p 50000:50000 \
    --mount type=bind,source=/opt/jenkins_home,target=/var/jenkins_home \
    --env JAVA_OPTS="-Djenkins.install.runSetupWizard=false" \
    --env JENKINS_OPTS="--argumentsRealm.roles.user=admin --argumentsRealm.passwd.admin=admin --argumentsRealm.roles.admin=admin" \
    jenkins/jenkins:lts
```
**IMPORTANT**:
This image (jenkins/jenkins:lts) is ignore variables argumentsRealm*
