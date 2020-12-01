#!/bin/bash

# Update packages
sudo apt -y update

# Upgrade packages
sudo apt -y upgrade

# Install docker
sudo apt -y install docker.io s3fs

# Variable path to jenkins home
JENKINS_HOME=/opt/jenkins_home

# Create Jenkins home
sudo mkdir -p $${JENKINS_HOME}

# Set permissions
sudo chmod -R 777 $${JENKINS_HOME}

# Start Jenkins
sudo docker run -d \
    --restart=always \
    --name jenkins \
    -p 80:8080 \
    -p 50000:50000 \
    --mount type=bind,source=$${JENKINS_HOME},target=/var/jenkins_home \
    jenkins/jenkins:lts

# temporary disabled
#   --env JAVA_OPTS="-Djenkins.install.runSetupWizard=false" \
#   --env JENKINS_OPTS="--argumentsRealm.roles.user=${JENKINS_USER_NAME} --argumentsRealm.passwd.admin=${JENKINS_USER_PASSWORD} --argumentsRealm.roles.admin=${JENKINS_USER_NAME}" \
