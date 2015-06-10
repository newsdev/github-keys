#!/usr/bin/env ruby

require 'json'
require 'open-uri'
require 'aws-sdk'

raise 'you must specify an HTTPS URL!' if ARGV.length < 1 or !ARGV[0].match(/^https:\/\//)
keys_url = ARGV[0]

raise 'you must specify a bucket!' if ARGV.length < 2
s3_bucket = ARGV[1]

raise 'you must specify an s3 key!' if ARGV.length < 3
s3_key = ARGV[2]

while true do
  keys = []

  open(ARGV[0]).read.split(/\s+/).delete_if{|u|u.match(/\W/)}.sort.uniq.each do |user|
    puts user
    open("https://api.github.com/users/#{user}/keys?access_token=#{ENV['GITHUB_TOKEN']}", "User-Agent" => "newsdev/github-keys") do |f|
  		JSON.parse(f.read).each_with_index do |key, i|
  			keys << key['key']
  		end
  	end
    sleep 2
  end

  obj ={
    bucket: s3_bucket,
    body: keys.join("\n"),
    key: s3_key,
    server_side_encryption: 'AES256',
    content_type: 'text/plain'
  }

  Aws::S3::Client.new(region: ENV['AWS_REGION'] || 'us-east-1').put_object(obj)
  puts '✓'
  sleep(10)
end
