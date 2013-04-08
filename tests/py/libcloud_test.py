#!/usr/bin/python

from libcloud.storage.types import Provider as StorageProvider
from libcloud.storage.types import ContainerDoesNotExistError
from libcloud.storage.providers import get_driver as get_storage_driver


import StringIO
import os
from common import s3_parsed_url, access_key, secret_key


class TestLibcloud:

    @classmethod
    def setup_class(cls):
        s3driver = get_storage_driver(StorageProvider.S3)
        # no calling format to specify apparently ?
        cls.connection = s3driver(key=access_key, 
                                  secret=secret_key, 
                                  secure=False, 
                                  host=s3_parsed_url.hostname,
                                  port=s3_parsed_url.port)
        

        try:
            bucket = cls.connection.get_container("libcloud_s3")
            for x in bucket.list_objects():
                print "Delete key: %s" % (x.name)
                x.delete()
            cls.connection.delete_container(bucket)
        except(ContainerDoesNotExistError):
            pass

    def test_01_create_bucket(self):
        """Creating a bucket"""
        bucket = self.connection.create_container("libcloud_s3")
        #assert bucket

    def test_02_add_key(self):
        """Adding a key"""
        fp = StringIO.StringIO()
        fp.write('This was uploaded to swift from libcloud.\n')
        fp.seek(0)
        bucket = self.connection.get_container("libcloud_s3")
        try:
            key = bucket.upload_object_via_stream( 
                         iterator = fp.readlines(),
                         object_name = "uploaded_from_s3.txt")
            fp.close()
        except(NotImplementedError):
            fp = open('/tmp/uploaded_from_s3.txt', 'w')
            fp.write('This was uploaded to swift from libcloud.\n')
            fp.close()
            key = bucket.upload_object( 
                         file_path = '/tmp/uploaded_from_s3.txt',
                         object_name = "uploaded_from_s3.txt")
            os.unlink('/tmp/uploaded_from_s3.txt')
        #assert key

    def test_03_modify_key(self):
        """Modifying a key"""
        bucket = self.connection.get_container("libcloud_s3")
        keys = [ x for x in bucket.list_objects() 
                 if x.name == "uploaded_from_s3.txt" ]
        assert len(keys) == 1
        fp = StringIO.StringIO()
        fp.write('This was modified/uploaded to swift from libcloud.\n')
        fp.seek(0)
        try:
            key = bucket.upload_object_via_stream( 
                         iterator = fp.readlines(),
                         object_name = "uploaded_from_s3.txt")
            fp.close()
        except(NotImplementedError):
            fp = open('/tmp/uploaded_from_s3.txt', 'w')
            fp.write('This was modified/uploaded to swift from libcloud.\n')
            fp.close()
            key = bucket.upload_object( 
                         file_path = '/tmp/uploaded_from_s3.txt',
                         object_name = "uploaded_from_s3.txt")
            os.unlink('/tmp/uploaded_from_s3.txt')
            

    def test_04_delete(self):
        """Deleting everything"""
        bucket = self.connection.get_container("libcloud_s3")
        for x in bucket.list_objects():
            print "Delete key: %s" % (x.name)
            x.delete()
        self.connection.delete_container(bucket)

