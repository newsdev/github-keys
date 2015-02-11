#!/usr/bin/env ruby

require 'json'
require 'open-uri'

raise 'you must specify an HTTPS URL!' unless ARGV[0].match(/^https:\/\//)

open(ARGV[0]).read.split(/\s+/).delete_if{|u|u.match(/\W/)}.sort.uniq.each do |user|
	open "https://api.github.com/users/#{user}/keys?access_token=#{ENV['GITHUB_TOKEN']}" do |f|
		JSON.parse(f.read).each_with_index do |key, i|
			puts key
			out = File.new("/data/keys/#{user}(#{i})@github.com", File::CREAT|File::TRUNC|File::RDWR, 0600)
			out.write(key['key'])
			out.close
		end
	end
end
