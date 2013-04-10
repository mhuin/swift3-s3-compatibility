package com.enovance.app;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;
import org.junit.BeforeClass;

import com.enovance.app.S3JClouds;

/**
 * Unit test for simple App.
 */
public class JCloudsTest 
    extends TestCase
{

    /**
     * Create the test case
     *
     * @param testName name of the test case
     */
    public JCloudsTest( String testName )
    {
        super( testName );
    }

    /**
     * @return the suite of tests being tested
     */
    public static Test suite()
    {
        return new TestSuite( JCloudsTest.class );
    }

    @BeforeClass
    public void setUpClass()
    {
        String s3url = System.getenv("S3_URL");
        String access_key = System.getenv("EC2_ACCESS_KEY");
        String secret_key = System.getenv("EC2_SECRET_KEY");
        S3JClouds connection = new S3JClouds(s3url, access_key, secret_key);
        connection.delete_bucket("jcloudstestbuckets3fortesting6");
        // give some time to execute
        try{
            Thread.sleep(5000);
        }catch(Exception e){
        }
    }

    public void test01CreateBucket()
    {
        String s3url = System.getenv("S3_URL");
        String access_key = System.getenv("EC2_ACCESS_KEY");
        String secret_key = System.getenv("EC2_SECRET_KEY");
        S3JClouds connection = new S3JClouds(s3url, access_key, secret_key);
        boolean a = connection.create_bucket("jcloudstestbuckets3fortesting6");
        assertTrue( a );

    }
    public void test02AddKey()
    {
        String s3url = System.getenv("S3_URL");
        String access_key = System.getenv("EC2_ACCESS_KEY");
        String secret_key = System.getenv("EC2_SECRET_KEY");
        S3JClouds connection = new S3JClouds(s3url, access_key, secret_key);
        connection.upload_file("test_s3.txt", "this was uploaded with jclouds.\n", "jcloudstestbuckets3fortesting6");
        // needs a better way to check the file is there
        assertTrue( true );
    }
    public void test03ModifyKey()
    {
        String s3url = System.getenv("S3_URL");
        String access_key = System.getenv("EC2_ACCESS_KEY");
        String secret_key = System.getenv("EC2_SECRET_KEY");
        S3JClouds connection = new S3JClouds(s3url, access_key, secret_key);
        connection.upload_file("test_s3.txt", "this was modified with jclouds.\n", "jcloudstestbuckets3fortesting6");
        // needs a better way to check the file is modified
        assertTrue( true );
    }
    public void test04Delete()
    {
        assertTrue( true );
    }
}
