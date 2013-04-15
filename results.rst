Tests results
=============

April 10, 2013


Test Methodology
----------------

Four libraries were tested:

* python: boto v 2.2.2-0ubuntu2 (available on ubuntu 12.04)
* python: libcloud v 0.5.0-1.1~build0.12.04.1 (available on ubuntu 12.04)
  and v 0.12.3 (pulled from PyPI)
* ruby: fog v 1.10.1 (latest version on the gem repository)
* java: jclouds v 1.5.9 (pulled from the maven repository)

All of these libraries allow to customize the S3 service endpoint easily.

For each library, a test was written to check whether simple operations were
possible:

* Creating a bucket
* Creating an object and uploading content
* Modifying an object
* Deleting an object
* Deleting a bucket

The tests were validated against a real S3 instance before being run on a 
devstack installation with swift3 and s3token middlewares activated.

The tested swift3 version is the master branch at the time of this writing.


Results
-------

boto
....

boto supports all of the operations listed above from the common library calls, 
provided that the ordinary call format for buckets is used, as swift3 doesn't 
support the vhost format. 
See http://docs.aws.amazon.com/AmazonS3/latest/dev/VirtualHosting.html

Modifying existing code to make the switch to a swift3 storage would just be a
matter of adding 3 parameters to the call to boto.connect_S3:

* host: the swift3 host address
* port: the service port
* calling_format: the calling format, as an instance of 
  boto.s3.connection.OrdinaryCallingFormat

libcloud
........

No operation could be validated on swift3. This is due to the way libcloud
authenticates itself: it uses a query authentication string rather than setting
an authorization header. 
See http://s3.amazonaws.com/doc/s3-developer-guide/RESTAuthentication.html

Swift3 does not seem to support query string authentication, although that case
seems to be taken care of in the current code:
https://github.com/fujita/swift3/blob/master/swift3/middleware.py#L810

The problem with QSA was reproduced with boto, leading to conclude QSA is not
functional in swift3 yet.

It is worthy to note that libcloud's s3 driver is not deemed production-ready
as of version 0.5.0 by its own maintainers anyway.

fog
...

fog supports all of the operations listed about from the common library calls,
as the support for buckets' ordinary call format was added recently. It is not
supported in the version of the library packaged for Ubuntu 12.04 .

There is a bug in the way fog evaluates the number of elements in a bucket when
using the ordinary call format, though. The maintainers have been notified of
it: https://github.com/fog/fog/issues/1631

Modifying existing code to make the switch to a swift3 storage would just be a
matter of adding the following parameters when calling Fog::Storage.new:

* scheme                   => "http" or "https"
* host                     => the service host
* port                     => the service port
* path_style               => true

jclouds
.......

Support is partial. While buckets can be created and deleted, it is impossible
to create, modify or delete objects in a bucket; attempts to do so trigger a
406 error ("Not Acceptable" : the server doesn't know how to respond to the
client) in the swift-container server. The proxy reforwards it as a "Not Found"
error.


