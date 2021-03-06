#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

if ARGV.empty?
  puts "   goal: test endpoints: sell_shop_item* (index, create, read, update, delete)"
  puts "  usage: #{$0} <config_file.yml>"
  puts "example: ruby #{$0} $CONFIG"
  exit
end

config_file =  ARGV[0]

c = BlommingApi::Client.new(config_file)

# shop_id == username
shop_id = c.username


# retrieve all shop's items
puts "shop: #{shop_id}, items:" 
data = c.all_pages (:stdout) do |page, per_page| 
  c.sell_shop_items page: page, per_page: per_page
end

data.each_with_index do |item, index|
  puts "#{index+1}: title: #{item["title"]}, id: #{item["id"]}"
end  

#
# CRUD = CREATE, READ, UPDATE, DELETE
#

# new item (as JSON payload)
new_item_json =
'{
  "category_id": "149",
  "user_id": "solyarismusic",
  "source_shipping_profile_id": "1",
  "price": 18.99,
  "title": "New item for test. title",
  "quantity": 1,
  "description": "New item for test. description",
  "published": false,
  "async_contents": ["http://solyaris4.altervista.org/solyarismusic_test_image.jpg"]
}'


# CREATE NEW ITEM
#----------------

user_id = shop_id

# Title: random value 
title = (0...8).map { (65 + rand(26)).chr }.join

# Description: random value
description = (0...50).map { ('a'..'z').to_a[rand(26)] }.join

# Photo URL: must be web available 
photo = "http://solyaris4.altervista.org/solyarismusic_test_image.jpg"

# Category_name: "Specialità:Musica" -> category_id: 149
music_category_id = 149.to_s

# Shipping_profile name: "Spedizione Gratis" -> id: 511452
free_shipping_id = 511452.to_s

# New item (created from a Ruby hash)
new_item = 
{
  "category_id" => music_category_id, 
  "user_id" => shop_id, 
  "source_shipping_profile_id" => free_shipping_id, 
  "price" => 18.99, 
  "title" => title, 
  "quantity" => 1, 
  "description" => description, 
  "published" => false, 
  "async_contents" => [ photo ]
}

puts
puts "new item:"
puts new_item
puts
puts "creating new item, shop: #{shop_id} ..."

# create item (Ruy hash)
response = c.sell_shop_item_create new_item

# get item ID from response 
item_id = response["id"]

puts "created item with id: #{item_id}"


# UPDATE ITEM
#------------

# duplicate item
updated_item = new_item.dup

# set quantity to a new value
updated_item["quantity"] = 10

puts
puts "updated item, with new 'quantity' value:"
puts updated_item
puts
puts "updating item with id: #{item_id}, shop: #{shop_id} ..."

c.sell_shop_item_update item_id, updated_item

puts "shop: #{shop_id}, updated item with id: #{item_id}"


# READ ITEM
#----------

puts
puts "reading item with id: #{item_id}, shop: #{shop_id} ..."

response = c.sell_shop_item_find item_id

#puts "read item:"
#puts response
#puts

# get updated quantity
updated_quantity = response["quantity"]

puts "shop: #{shop_id}, read item with id: #{item_id}, (updated quantity value: #{updated_quantity})"
#c.dump_pretty json

# DELETE ITEM
#------------
puts
puts "deleting item with id: #{item_id}, shop: #{shop_id} ..."

c.sell_shop_item_delete item_id

puts "deleted item with id: #{item_id}"
