#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

if ARGV[0].nil? || ARGV[1].nil?
  puts "usage: #{$0} <config_file.yml> <shop_id>\n"
  puts "example: ruby #{$0} ./config/yourconfig.yml solyarismusic"
  exit
end   

config_file = ARGV[0]
shop_id = ARGV[1]

c = BlommingApi::Client.new config_file 

# all items of shop_id
data = c.all_pages do |page, per_page| 
  c.shops_items( shop_id, {:page => page, :per_page => per_page} )
end	 

# items list to stdout 
puts "shop: #{shop_id}, items:" 
data.each_with_index do |item, index| 
  puts "#{index+1}: title: #{item["title"]}, id: #{item["id"]}"
end