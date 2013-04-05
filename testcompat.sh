#!/usr/bin/env bash

# Testing common S3 client libraries compatibility with Swift3 on a 
# "Devstack" Ubuntu Server VM (and documenting what I am doing at the same time)
# run this script on the VM.

#-- installing what's needed for devstack

sudo aptitude update && sudo aptitude install python-netaddr git python-boto python-libcloud
if [ ! -d ./devstack ]; then 
    echo "pulling devstack"
    echo "------------"
    git clone git://github.com/openstack-dev/devstack.git
    cd devstack
else
    echo "Unstacking and updating devstack"
    echo "------------"
    cd devstack && ./unstack.sh 
    git pull
fi

#-- adding a localrc to install the bare minimum

cat > localrc << "EOF"
ADMIN_PASSWORD=ADMIN
KEYSTONE_TOKEN_FORMAT=UUID
ENABLED_SERVICES=key,mysql,swift,swift3
LOGFILE=/tmp/devstack.log
MYSQL_PASSWORD=mysqlpassword
RABBIT_PASSWORD=8112166274b4f0198723
SCREEN_LOGDIR=/tmp/screen-logs
SERVICE_PASSWORD=ADMIN
SERVICE_TOKEN=7f00aa2752e42ff6eead
SWIFT_HASH=8519b430eb14d5983334
SWIFT_REPLICAS=1
EOF

./stack.sh

#-- Getting S3 like tokens
source eucarc demo demo
echo "EC2 URL is $EC2_URL"
echo "S3 URL is $S3_URL"
echo "demo:demo EC2 access key is $EC2_ACCESS_KEY"
echo "demo:demo EC2 secret key is $EC2_SECRET_KEY"


#-- boto
echo "Testing boto library"
echo "------------"

cd .. && python boto_test.py
