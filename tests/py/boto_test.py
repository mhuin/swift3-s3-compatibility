#!/usr/bin/python
# inspired from https://gist.github.com/chmouel/5310982


import boto
import boto.s3.connection
import boto.s3.key
import boto.exception
import StringIO
from common import s3_parsed_url, access_key, secret_key


class TestBoto:

    @classmethod
    def setup_class(cls):
        cls.connection = boto.connect_s3(
            aws_access_key_id=access_key,
            aws_secret_access_key=secret_key,
            port=s3_parsed_url.port,
            host=s3_parsed_url.hostname,
            is_secure=False,
            calling_format=boto.s3.connection.OrdinaryCallingFormat())

        try:
            bucket = cls.connection.get_bucket("boto_s3")
            for x in bucket.get_all_keys():
                print "Delete key: %s" % (x.name)
                x.delete()
            connection.delete_bucket("boto_s3")
        except(boto.exception.S3ResponseError):
            pass

    def test_01_create_bucket(self):
        """Creating a bucket""",
        bucket = self.connection.create_bucket("boto_s3")
        #assert bucket

    def test_02_add_key(self):
        """Adding a key"""
        fp = StringIO.StringIO()
        fp.write('This was uploaded to swift from Boto.\n')
        bucket = self.connection.get_bucket("boto_s3")
        key = boto.s3.key.Key(bucket, "uploaded_from_s3.txt")
        key.set_contents_from_file(fp)
        fp.close()
        #assert key

    def test_03_modify_key(self):
        """Modifying a key"""
        bucket = self.connection.get_bucket("boto_s3")
        keys = [ x for x in bucket.get_all_keys() 
                 if x.name == "uploaded_from_s3.txt" ]
        assert len(keys) == 1
        fp = StringIO.StringIO()
        fp.write('This was modified/uploaded to swift from Boto.\n')
        keys[0].set_contents_from_file(fp)
        fp.close()
        #assert keys[0]

    def test_04_delete(self):
        """Deleting everything"""
        bucket = self.connection.get_bucket("boto_s3")
        for x in bucket.get_all_keys():
            x.delete()
        self.connection.delete_bucket("boto_s3")

