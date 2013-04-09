#!/usr/bin/env bash

# Testing common S3 client libraries compatibility with Swift3 on a 
# "Devstack" Ubuntu Server VM (and documenting what I am doing at the same time)
# run this script on the VM.
# It is assumed the devstack environment is ready. If not, run setdevstack.sh

# do not forget to source eucarc before !

# or set your own credentials in a file
[ -f S3Keys ] && source S3Keys

#-- boto
echo "Testing boto library"
echo "------------"

nosetests tests/py/boto_test.py -v

#-- libcloud
echo "Testing libcloud library"
echo "------------"

nosetests tests/py/libcloud_test.py -v

#-- fog
echo "Testing fog library"
echo "------------"

# use rubygems if not working
testoutput="$(ruby tests/rb/fog_test.rb 2>&1)"
if [[ "$testoutput" =~ "fog (LoadError)" ]]
then 
    ruby -r rubygems tests/rb/fog_test.rb
else
    echo "$testoutput"
fi

#-- jclouds
#echo "Testing jclouds library"
#echo "------------"


