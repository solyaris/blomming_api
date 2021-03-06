#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

if ARGV[0].nil? || ARGV[1].nil?
  puts "   goal: test endpoint: categories, category_items"
  puts "  usage: #{$0} <config_file.yml> <category_name>" 
  puts "example: ruby #{$0} $CONFIG \"Casa:Giardino & Outdoor\""
  exit
end

config_file = ARGV[0]
category_name = ARGV[1]

c = BlommingApi::Client.new config_file 

# retrieve all blomming categories names 
categories = c.categories

# get id (numeric identificator) associated to a certain category name (string identificator)
category_id = BlommingApi::PublicHelpers::id_from_name category_name, categories

unless category_id
  puts "category name: #{category_name} not found among Blomming categories"
  exit
else
  puts "searching items for category name: \"#{category_name}\" (category_id: #{category_id})"
end	

# retrieve all items data associated to a category
all_items = c.all_pages (:stdout) do |page, per_page| 
  c.category_items( category_id, {page: page, per_page: per_page} )
end   

# for each item: print on stdout a subset of data fields (item title, item id, shop id)
all_items.each_with_index do |item, index| 
  puts "#{index+1}: title: #{item["title"]}, id: #{item["id"]}, shop: #{item["shop"]["id"]}"
end