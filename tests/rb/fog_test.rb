# test fog compatibility with swift3

require 'fog'
require "test/unit"
require File.expand_path(File.dirname(__FILE__) + "/common.rb")

# Do not verify SSL (less secure)
require 'excon'
Excon.defaults[:ssl_verify_peer] = false

class TestFog < Test::Unit::TestCase
    # ruby TestCase doesn't have anything similar to setup_class
    begin
        # fix to support ordinary paths calls rather than subdomain calls
        # see https://github.com/fog/fog/issues/1631
        # the pull request was a month old at the time of this writing, so
        # the fix might not be in current packaged versions of the library.
        @@connection = Fog::Storage.new({
              :provider                 => 'AWS',
              :aws_secret_access_key    => SECRET_KEY,
              :aws_access_key_id        => ACCESS_KEY,
              :scheme                   => 'http',
              :host                     => S3_HOST,
              :port                     => S3_PORT,
              :path_style               => true
            })
    rescue
        @@connection = Fog::Storage.new({
              :provider                 => 'AWS',
              :aws_secret_access_key    => SECRET_KEY,
              :aws_access_key_id        => ACCESS_KEY,
              :scheme                   => 'http',
              :host                     => S3_HOST,
              :port                     => S3_PORT,
            })
    end
    begin
        bucket = @@connection.directories.get("fogs3testing")
        bucket.files.each do |to_discard|
            to_discard.destroy
        end
        bucket.destroy
        puts "cleaned previously existing test bucket"
    rescue
        puts "no cleanup needed, woohoo"
    end 

    def test_01_create_bucket
        bucket = @@connection.directories.create(
          :key                      => "fogs3testing",
          :public                   => true)
        assert_equal(1, @@connection.directories.size)
    end

    def test_02_add_key
        bucket = @@connection.directories.get("fogs3testing")
        file = bucket.files.create(
          :key                      => 'data.txt',
          :body                     => "This was uploaded with the fog library"
        )
        assert_equal(1, bucket.files.all.size)
        assert_nil(bucket.files.head('non_existent_file.txt'))
        assert_not_nil(bucket.files.head('data.txt'))
    end

    def test_03_modify_key
        bucket = @@connection.directories.get("fogs3testing")
        file = bucket.files.get('data.txt')
        file.body = "This was modified with the fog library"
        file.save
        assert("This was modified with the fog library", 
               bucket.files.get('data.txt').body)
    end

    def test_04_delete
        bucket = @@connection.directories.get("fogs3testing")
        bucket.files.each do |to_discard|
            to_discard.destroy
        end
        bucket.destroy
        assert_equal(0, @@connection.directories.size)
    end

    
end
