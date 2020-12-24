#!/bin/bash

################################################################################
# Detect OS
################################################################################
OS="unknown"
VER="unknown"

if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    OS=Debian
    VER=$(cat /etc/debian_version)
elif [ -f /etc/SuSe-release ]; then
    # Older SuSE/etc.
    ...
elif [ -f /etc/redhat-release ]; then
    # Older Red Hat, CentOS, etc.
    ...
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS=$(uname -s)
    VER=$(uname -r)
fi

################################################################################
# Update and install software
################################################################################
PACKAGES_COMMON="vim"
PACKAGES_CENTOS="docker amazon-efs-utils"
PACKAGES_DEBIAN_BASED="docker.io ntfs-common s3fs"

# For Amazon linux
if [ $${OS} = "Amazon Linux" || $${OS} = "CentOS" ]; then
    yum update -y
    yum upgrade -y
    yum install -y $${PACKAGES_COMMON} $${PACKAGES_CENTOS}
fi

# For Ubuntu & Debian
if [ $${OS} = "Ubuntu" ] || [ $${OS} -qe "Debian" ]; then
    apt update -y
    apt upgrade -y
    apt install -y $${PACKAGES_COMMON} $${PACKAGES_DEBIAN_BASED}
fi

################################################################################
# Prepare Jenkins home
################################################################################
# Variable path to jenkins home
JENKINS_HOME=/opt/jenkins_home

# Create Jenkins home
mkdir -p $${JENKINS_HOME}

# Set permissions
chmod -R 777 $${JENKINS_HOME}

# Mount EFS
if [ ${MOUNT_EFS} ]; then
  # For Amazon linux
  if [ $${OS} = "Amazon Linux" || $${OS} = "CentOS" ]; then
      mount -t efs -o tls ${EFS_DNS_NAME}:/ $${JENKINS_HOME}
      echo "${EFS_DNS_NAME}:/ $${JENKINS_HOME} efs defaults,_netdev 0 0" >> /etc/fstab
  fi

  # For Ubuntu & Debian
  if [ $${OS} = "Ubuntu" ] || [ $${OS} -qe "Debian" ]; then
      mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${EFS_DNS_NAME}:/   $${JENKINS_HOME}
      echo "${EFS_DNS_NAME}:/ $${JENKINS_HOME} nfs defaults,_netdev 0 0" >> /etc/fstab

  fi

fi

################################################################################
# Run docker
################################################################################
# Start Jenkins
docker run -d \
    --restart=always \
    --name jenkins \
    -p 80:8080 \
    -p 50000:50000 \
    --mount type=bind,source=$${JENKINS_HOME},target=/var/jenkins_home \
    jenkins/jenkins:lts

# temporary disabled
#   --env JAVA_OPTS="-Djenkins.install.runSetupWizard=false" \
#   --env JENKINS_OPTS="--argumentsRealm.roles.user=${JENKINS_USER_NAME} --argumentsRealm.passwd.admin=${JENKINS_USER_PASSWORD} --argumentsRealm.roles.admin=${JENKINS_USER_NAME}" \
