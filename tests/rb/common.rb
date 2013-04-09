require 'uri'

uri = URI(ENV['S3_URL'])

S3_HOST = uri.host
S3_PORT = uri.port
ACCESS_KEY = ENV['EC2_ACCESS_KEY']
SECRET_KEY = ENV['EC2_SECRET_KEY']


