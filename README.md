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
