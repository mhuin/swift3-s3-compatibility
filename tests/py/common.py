#!/usr/bin/python

import sys
import os
import urlparse

s3_url = os.environ.get('S3_URL')
if not s3_url:
    print "Source your devstack eucarc or provide a " \
          "S3_URL EC2_SECRET_KEY EC2_SECRET_KEY env variable."
    sys.exit(1)

s3_parsed_url = urlparse.urlparse(s3_url)
access_key = os.environ.get('EC2_ACCESS_KEY')
secret_key = os.environ.get('EC2_SECRET_KEY')

if __name__ == "__main__":
    print s3_parsed_url
    print access_key
    print secret_key
