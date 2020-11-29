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

## local run jenkins
```
docker run -d \
    --restart=always \
    --name jenkins \
    -p 8888:8080 \
    -p 50000:50000 \
    --mount type=bind,source=/opt/jenkins_home,target=/var/jenkins_home \
    --env JENKINS_ADMIN_ID=admin \
    --env JENKINS_ADMIN_PASSWORD=password \
    --env JAVA_OPTS="-Djenkins.install.runSetupWizard=false" \
    jenkins/jenkins:lts
```
