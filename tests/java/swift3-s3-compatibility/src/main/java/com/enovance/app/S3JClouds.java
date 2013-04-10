package com.enovance.app;

/**
 * Jcloud
 *
 */

import static org.jclouds.s3.reference.S3Constants.PROPERTY_S3_VIRTUAL_HOST_BUCKETS;
import org.jclouds.ContextBuilder;
import org.jclouds.blobstore.BlobStore;
import org.jclouds.blobstore.BlobStoreContext;
import org.jclouds.blobstore.domain.Blob;
import java.util.Properties;

public class S3JClouds 
{
    public String s3url;
    public String access_key;
    public String secret_key;
    public BlobStore blobStore;
    
    public S3JClouds(String url, String a_key, String s_key)
    {
        // see http://stackoverflow.com/questions/9389840/use-jclouds-to-talk-to-non-aws-cloud-with-s3-api
        Properties overrides = new Properties();
        overrides.setProperty(PROPERTY_S3_VIRTUAL_HOST_BUCKETS, "false");

        s3url = url;
        access_key = a_key;
        secret_key = s_key;
        blobStore = ContextBuilder.newBuilder("s3")
                                         .endpoint(url)
                                         .credentials(a_key, s_key)
                                         .overrides(overrides)
                                         .buildView(BlobStoreContext.class).getBlobStore();
    }
    
    public void delete_bucket(String bucketname)
    {
        blobStore.deleteContainer(bucketname);
    }
    
    public boolean create_bucket(String bucketname)
    {
        // Create Container
        boolean created = blobStore.createContainerInLocation(null, bucketname);
        return created;
    }

    public void upload_file(String filename, String payload, String bucketname)
    {
        Blob blob = blobStore.blobBuilder(filename).payload(payload).build();
        blobStore.putBlob(bucketname, blob);
    }

    public void delete_file(String bucketname, String filename)
    {
        blobStore.removeBlob(bucketname, filename);
    }

//    public static void main( String[] args )
//    {
//        System.out.println( "Hello World!" );
//    }

}
