package com.enovance.app;

/**
 * Jcloud
 * My java is VERY rusty !
 */

import static org.jclouds.s3.reference.S3Constants.PROPERTY_S3_VIRTUAL_HOST_BUCKETS;
import org.jclouds.ContextBuilder;
import org.jclouds.blobstore.BlobStore;
import org.jclouds.blobstore.BlobStoreContext;
import org.jclouds.blobstore.domain.Blob;
import java.util.Properties;
import java.io.IOException;

//import org.jclouds.logging.log4j.config.Log4JLoggingModule;
//import org.jclouds.logging.config.ConsoleLoggingModule;
import com.google.inject.Module;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Iterables;

public class S3JClouds 
{
    public String s3url;
    public String access_key;
    public String secret_key;
    public Properties overrides;
    
    public S3JClouds(String url, String a_key, String s_key)
    {
        // see http://stackoverflow.com/questions/9389840/use-jclouds-to-talk-to-non-aws-cloud-with-s3-api
        overrides = new Properties();
        overrides.setProperty(PROPERTY_S3_VIRTUAL_HOST_BUCKETS, "false");

        s3url = url;
        access_key = a_key;
        secret_key = s_key;
    }
    
    public BlobStoreContext get_context()
    {
//        Iterable<Module> modules = ImmutableSet.<Module> of(new ConsoleLoggingModule());
        BlobStoreContext ctx = ContextBuilder.newBuilder("s3")
                                 .endpoint(s3url)
                                 .credentials(access_key, secret_key)
                                 .overrides(overrides)
//                                 .modules(modules)
                                 .buildView(BlobStoreContext.class);
        return ctx;
    }
    
    public void delete_bucket(String bucketname)
    {
        BlobStoreContext ctx = this.get_context();
        BlobStore blobStore = ctx.getBlobStore();
        blobStore.deleteContainer(bucketname);
        ctx.close();
    }
    
    public boolean create_bucket(String bucketname)
    {
        BlobStoreContext ctx = this.get_context();
        BlobStore blobStore = ctx.getBlobStore();
        // Create Container
        boolean created = blobStore.createContainerInLocation(null, bucketname);
        ctx.close();
        return created;
    }

    public void upload_file(String filename, String payload, String bucketname)
    {
        BlobStoreContext ctx = this.get_context();
        BlobStore blobStore = ctx.getBlobStore();
        Blob blob = blobStore.blobBuilder(filename).payload(payload).build();
        blobStore.putBlob(bucketname, blob);
        ctx.close();
    }

    public void delete_file(String bucketname, String filename)
    {
        BlobStoreContext ctx = this.get_context();
        BlobStore blobStore = ctx.getBlobStore();
        blobStore.removeBlob(bucketname, filename);
        ctx.close();
    }

}
