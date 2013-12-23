#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

if ARGV.empty?
  puts "usage: #{$0} <config_file.yml>" 
  exit
end

config_file =  ARGV[0]
shop_id = "solyarismusic"

c = BlommingApi::Client.new(config_file)

# retrieve all shop's items
puts "shop: #{shop_id}, items:" 
data = c.all_pages do |page, per_page| 
  c.sell_shop_items( shop_id, {page: page, per_page: per_page} )
end

data.each_with_index do |item, index|
  puts "#{index+1}: title: #{item["title"]}, id: #{item["id"]}"
end  

#
# CRUD = CREATE, READ, UPDATE, DELETE
#

=begin
# new item (as JSON payload)
new_item_json =
'{
  "category_id": "48",
  "user_id": "solyarismusic",
  "source_shipping_profile_id": "1",
  "price": 18.99,
  "title": "New item for test. title",
  "quantity": 1,
  "description": "New item for test. description",
  "published": false,
  "async_contents": ["http://solyaris4.altervista.org/solyarismusic_test_image.jpg"]
}'
=end

# CREATE NEW ITEM
#----------------

# new item (as ruby hash)
new_item = 
{
  "category_id" => "48", 
  "user_id" => "solyarismusic", 
  "source_shipping_profile_id" => "1", 
  "price" => 18.99, 
  "title" => "New item for test. title", 
  "quantity" => 1, 
  "description" => "New item for test. description", 
  "published" => false, 
  "async_contents" => ["http://solyaris4.altervista.org/solyarismusic_test_image.jpg"]
}

puts
puts "new item:"
puts new_item
puts
puts "creating new item, shop: #{shop_id} ..."

# create item (Ruy hash)
response = c.sell_shop_items_create new_item

# get item ID from response 
item_id = response["id"]

puts "created item with id: #{item_id}"


# UPDATE ITEM
#------------
# update field quantity
updated_item = new_item.merge({ "quantity" => 22 })

puts
puts "updated item, with new 'quantity' value:"
puts updated_item
puts
puts "updating item with id: #{item_id}, shop: #{shop_id} ..."

c.sell_shop_items_update item_id, updated_item

puts "shop: #{shop_id}, updated item with id: #{item_id}"


# READ ITEM
#----------

puts
puts "reading item with id: #{item_id}, shop: #{shop_id} ..."

response = c.sell_shop_items_read item_id

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

c.sell_shop_items_delete item_id

puts "deleted item with id: #{item_id}"
