#!/usr/bin/env bash

# Testing common S3 client libraries compatibility with Swift3 on a 
# "Devstack" Ubuntu Server VM (and documenting what I am doing at the same time)
# run this script on the VM.
# It is assumed the devstack environment is ready. If not, run setdevstack.sh



#-- boto
echo "Testing boto library"
echo "------------"

python tests/py/boto_test.py

#-- libcloud
echo "Testing libcloud library"
echo "------------"

python tests/py/libcloud_test.py

#-- fog
echo "Testing lfog library"
echo "------------"

ruby tests/rb/fog_test.rb

#-- jclouds
echo "Testing jclouds library"
echo "------------"


