#!/usr/bin/env bash

# Testing common S3 client libraries compatibility with Swift3 on a 
# "Devstack" Ubuntu Server VM (and documenting what I am doing at the same time)
# run this script on the VM.
# It is assumed the devstack environment is ready. If not, run setdevstack.sh

# needed dependencies and libraries and what have you

sudo aptitude update && sudo aptitude install python-boto python-libcloud \
     ruby-fog ruby rubygems maven python-nose openjdk-6-jdk

#-- uncomment to install fog from gem
# sudo gem install fog

# looking for your own credentials in a file
[ -f S3Keys ] && source S3Keys

# uncomment to get S3-like credentials for swift3
#source /PATH/TO/DEVSTACK/eucarc
#echo "EC2 URL is $EC2_URL"
#echo "S3 URL is $S3_URL"
#echo "EC2 access key is $EC2_ACCESS_KEY"
#echo "EC2 secret key is $EC2_SECRET_KEY"

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


