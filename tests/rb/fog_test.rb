# test fog compatibility with swift3

require 'fog'
require "test/unit"
require "./common.rb"
 
class TestFog < Test::Unit::TestCase
    # ruby TestCase doesn't have anything similar to setup_class
    @connection = Fog::Storage.new({
      :provider                 => 'AWS',
      :aws_secret_access_key    => ACCESS_KEY,
      :aws_access_key_id        => SECRET_KEY,
      :host                     => S3_HOST,
      :port                     => S3_PORT
    })
    begin
        bucket = @connection.directories.get("fogs3testing")
        bucket.files.each do |to_discard|
            to_discard.destroy
        end
        bucket.destroy
    rescue
        puts "no cleanup needed, woohoo"
    end

    def test_01_create_bucket
        assert(false, "Not implemented yet")
    end

    def test_02_add_key
        assert(false, "Not implemented yet")
    end

    def test_03_modify_key
        assert(false, "Not implemented yet")
    end

    def test_04_delete
        assert(false, "Not implemented yet")
    end

#    directory = connection.directories.get("all-my-data")

#    local_file = File.open("/path/to/my/data.txt", "w")
#    file = directory.files.get('data.txt')
#    local_file.write(file.body)
#    local_file.close

#    file = directory.files.get('data.txt')
#    file.body = File.open("/path/to/my/data.txt")
#    file.save
    
end
