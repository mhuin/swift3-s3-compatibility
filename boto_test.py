#!/usr/bin/python
# inspired from https://gist.github.com/chmouel/5310982


import boto
import sys
import boto.s3.connection
import boto.s3.key
import boto.exception
import StringIO
import os
import urlparse

s3_url = os.environ.get('S3_URL')
if not s3_url:
    print "Source your devstack eucarc or provide a " \
            "S3_URL EC2_SECRET_KEY EC2_SECRET_KEY env variable."
    sys.exit(1)

parsed = urlparse.urlparse(s3_url)

print parsed

connection = boto.connect_s3(
    aws_access_key_id=os.environ.get('EC2_ACCESS_KEY'),
    aws_secret_access_key=os.environ.get('EC2_SECRET_KEY'),
    port=parsed.port,
    host=parsed.hostname,
    is_secure=False,
    calling_format=boto.s3.connection.OrdinaryCallingFormat())

try:
    bucket = connection.get_bucket("boto_s3")
    for x in bucket.get_all_keys():
        print "Delete key: %s" % (x.name)
        x.delete()
    print "Deleting bucket: boto_s3"
    connection.delete_bucket("boto_s3")
except(boto.exception.S3ResponseError):
    pass

flag = False

print "Creating bucket: boto_s3 ",
try:
    bucket = connection.create_bucket("boto_s3")
    print "[PASSED]"
    flag = True
except:
    print "[FAILED]"

if flag:
    try:
        fp = StringIO.StringIO()
        fp.write('This was uploaded to swift from Boto.\n')
        print "Adding a key ", 
        key = boto.s3.key.Key(bucket, "uploaded_from_s3.txt")
        key.set_contents_from_file(fp)
        fp.close()
        print "[PASSED]"
    except:
        flag = False
        print "[FAILED]"

if flag:
    #Modify
    print "Modifying a key ",
    bucket = connection.get_bucket("boto_s3")
    for x in bucket.get_all_keys():
        if x.name == "uploaded_from_s3.txt":
            fp = StringIO.StringIO()
            fp.write('This was modified/uploaded to swift from Boto.\n')
            key.set_contents_from_file(fp)
            fp.close()
            print "[PASSED]"
    try:
        bucket = connection.get_bucket("boto_s3")
        for x in bucket.get_all_keys():
            print "Delete key: %s" % (x.name)
            x.delete()
        print "Deleting bucket: boto_s3"
        connection.delete_bucket("boto_s3")
    except(boto.exception.S3ResponseError):
        pass
