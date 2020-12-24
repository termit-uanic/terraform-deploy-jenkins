# terraform-deploying-jenkins
Module for deploying jenkins in AWS

## Before run terraform you should have environment variables
```
$ export AWS_ACCESS_KEY_ID= <your key> # to store and retrieve the remote state in s3.
$ export AWS_SECRET_ACCESS_KEY= <your secret>
$ export AWS_DEFAULT_REGION= <your bucket region e.g. us-west-2>
```

## Key pair
You should have ssh key in EC2 Key Pairs.

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
| company\_name | The name of company. Name is without under score, lowercase letter. | string | mycompany | no |
| region | The AWS region to create resources in | string | eu-central-1 | no |
| availability\_zone | The key availability zone in region | string | b | no |
| ami\_owners | The owners of ami images for search | list | ["099720109477"] | no |
| ami\_search\_strings | The array of search strings as part name of image | list | ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-*"] | no |
| ami\_arch | The architecture for image | list | ["x86_64"] | no |
| tag\_enviroment | The value tag enviroment | string | production | no |
| jenkins\_name | The name of the Jenkins server string | jenkins | no |
| instance\_type | Kind of type instance | string | t2.micro | no |
| cidr\_block | The CIDR block for vpc and subnet | string | 192.168.1.0/24 | no |
| key\_name | SSH key name in your AWS account for AWS instances | string | jenkins | no |
| create\_s3\_bucket | Create S3 bucket for backup or not | bool | true | no |
| create\_efs\_drive | Create EFS partition for Jenkins data | bool | true | no |
| jenkins\_user\_name | The user name in Jenkins. **Important**: This variable is not used now. Image Jenkins ignore that. | string | admin | no |
| jenkins\_user\_password | The user password in Jenkins. **Important**: This variable is not used now. Image Jenkins ignore that. | string | PaSsw0rD | no |

## Outputs

| Name | Description |
|------|-------------|
| jenkins\_public\_dns | The public DNS name of Jenkins instance. |
| jenkins\_public\_ip | The public IP address of Jenkins instance. |

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
