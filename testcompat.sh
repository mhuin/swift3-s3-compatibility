#!/usr/bin/env bash

# Testing common S3 client libraries compatibility with Swift3 on a 
# "Devstack" Ubuntu Server VM (and documenting what I am doing at the same time)
# run this script on the VM.
# It is assumed the devstack environment is ready. If not, run setdevstack.sh

# do not forget to source eucarc before !

#-- boto
echo "Testing boto library"
echo "------------"

nosetests tests/py/boto_test.py -v

#-- libcloud
echo "Testing libcloud library"
echo "------------"

nosetests tests/py/libcloud_test.py

#-- fog
echo "Testing lfog library"
echo "------------"

ruby tests/rb/fog_test.rb

#-- jclouds
echo "Testing jclouds library"
echo "------------"


