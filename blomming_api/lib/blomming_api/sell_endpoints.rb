# encoding: utf-8
require 'multi_json'
require 'rest_client'

module BlommingApi
  module SellEndpoints

    #
    # SELL
    # PAYMENT_TYPES
    #

    #
    # Get the current Payment Type
    #
    def sell_payment_types_find (params={})
      url = api_url "/sell/payment_types​/user_list"
      req = request_params(params)

      feed_or_retry do
        RestClient.get url, req
      end  
    end

    #
    # Create a new Payment Type
    #
    def sell_payment_types_create (email, params={})
      url = api_url "/sell/payment_types​/new"
      load = MultiJson.dump email: email
      req = request_params(params)

      feed_or_retry do
        RestClient.post url, load, req 
      end  
    end

    #
    # Edit a Payment Type
    #
    def sell_payment_types_update (payment_type_id, email, params={})
      url = api_url "/sell/payment_types​/#{payment_type_id}"
      load = MultiJson.dump email: email
      req = request_params(params)

      feed_or_retry do
        RestClient.put url, load, req 
      end  
    end

    #
    # Delete a Payment Type
    #
    def sell_payment_types_delete (payment_type_id, params={})
      url = api_url "/sell/payment_types​/#{payment_type_id}"
      req = request_params(params)

      feed_or_retry do
        RestClient.delete url, req 
      end  
    end

    #
    # SELL
    # REGISTER
    #

    #
    # Register a new account to blomming 
    #
    def sell_register (payload, params={})
      url = api_url "/sell/register"
      load = MultiJson.dump payload
      req = request_params(params)

      feed_or_retry do
        RestClient.post url, load, req 
      end  
    end

    #
    # SELL
    # SHIPPING_COUNTRIES
    #

    #
    # Get the full list of the possible Countries
    # for the shipping profile, localized.
    #
    def sell_shipping_countries_all (params={})
     req = request_params({locale: @locale}.merge(params))

      feed_or_retry do
        RestClient.get url, req
      end  
    end

    #
    # SELL
    # SHIPPING_PROFILES
    #

    #
    # Get all the shipping profiles associated to the user
    # 
    def sell_shipping_profiles (params={})
      url = api_url "/sell/shipping_profiles"
      req = request_params(params)

      feed_or_retry do
        RestClient.get url, req
      end
    end

    #
    # Create a new Shipping Profile
    # 
    # example:
    #
    #   shipping_profile = 
    #   { "name":"National shipping", 
    #     "origin_country_code":"IT", 
    #     "everywhere_else_cost_single":10, 
    #     "everywhere_else_cost_shared":5 
    #   }
    #
    #   blomming.sell_shipping_profile_create shipping_profile 
    #
    def sell_shipping_profile_create (shipping_profile, params={})
      url = api_url "/sell/shipping_profiles"
      load = MultiJson.dump shipping_profile
      req = request_params(params)

      feed_or_retry do
        RestClient.post url, load, req 
      end  
    end

    #
    # Edit a Shipping Profile
    #
    def sell_shipping_profile_update (id, shipping_profile, params={})
      url = api_url "/sell/shipping_profiles/#{id}"
      load = MultiJson.dump shipping_profile
      req = request_params(params)

      feed_or_retry do
        RestClient.put url, load, req 
      end  
    end

    #
    # Delete a Shipping Profile
    #
    def sell_shipping_profile_delete (id, params={})
      url = api_url "/sell/shipping_profiles/#{id}"
      req = request_params(params)

      feed_or_retry do
        RestClient.delete url, req 
      end  
    end

    #
    # Get the shipping profile that has the id given
    #
    def sell_shipping_profile_find (id, params={})
      url = api_url "/sell/shipping_profiles/#{id}"
      req = request_params(params)

      feed_or_retry do
        RestClient.get url, req 
      end  
    end

    #
    # Create a Shipping Profile and assign it to an Item
    #
    def sell_shipping_profile_item_create (payload, item_id, params={})
      url = api_url "/sell/shipping_profiles/items​/#{item_id}"
      load = MultiJson.dump payload
      req = request_params(params)

      feed_or_retry do
        RestClient.post url, load, req 
      end  
    end


    #
    # SELL
    # SHIPPING_REGIONS
    #

    #
    # Get the full list of the possible Regions 
    # for the shipping profile, localized.
    # 
    def sell_shipping_regions (params={})
      url = api_url "/sell/shipping_regions​/all"
      req = request_params({locale: @locale}.merge(params))

      feed_or_retry do
        RestClient.get url, req
      end  
    end

    #
    # SELL
    # SHOP_DASHBOARD
    #

    #
    # Get shop dashboard details, 
    # that are products count, orders count and total revenue
    #
    def sell_shop_dashboard (params={})
      url = api_url "/sell/shop/dashboard"
      req = request_params({locale: @locale}.merge(params))

      feed_or_retry do
        RestClient.get url, req
      end  
    end

    #
    # SELL
    # SHOP_ITEMS
    #

    #
    # Returns an ordered, paginated list of all the items 
    # (pubished or not) present on a given shop.
    #
    def sell_shop_items (params={})
      url = api_url "/sell/shop/items"
      req = request_params(params)

      feed_or_retry do
        RestClient.get url, req
      end  
    end

    #
    # Create a new shop item
    #
    # example:
    #
    # item = { "category_ids": [101], 
    #          "source_shipping_profile_id": "", 
    #          "price": 8.50, 
    #          "title": "An Item", 
    #          "quantity": 1, 
    #          "description": "New description", 
    #          "published": true, 
    #          "original_price": 10.00 
    #        }
    #
    # blomming.sell_shop_item_create item 
    #
    def sell_shop_item_create (item, params={})
      url = api_url "/sell/shop/items/new"
      load = MultiJson.dump item
      req = request_params(params)

      feed_or_retry do
        RestClient.post url, load, req 
      end  
    end

    #
    # Returns one of shop products’ details
    #
    def sell_shop_item_find (item_id, params={})
      url = api_url "/sell/shop/items/#{item_id}"
      req = request_params(params)

      feed_or_retry do
        RestClient.get url, req
      end  
    end

    #
    # Update some of the properties of the Item
    #
    # example:
    #
    # item = { "category_ids": [101], 
    #          "source_shipping_profile_id": "", 
    #          "price": 8.50, 
    #          "title": "An Item", 
    #          "quantity": 1, 
    #          "description": "New description", 
    #          "published": true, 
    #          "original_price": 10.00 
    #        }
    #
    # blomming.sell_shop_item_update 60034, item 
    #    
    #
    def sell_shop_item_update (item_id, item, params={})
      url = api_url "/sell/shop/items/#{item_id}"
      load = MultiJson.dump item
      req = request_params(params)

      feed_or_retry do
        RestClient.put url, load, req
      end    
    end

    #
    # Delete an item given an id
    #
    def sell_shop_item_delete (item_id, params={})
      url = api_url "/sell/shop/items/#{item_id}"
      req = request_params(params)

      feed_or_retry do
        RestClient.delete url, req
      end  
    end

    #
    # Add one or more Tag to an Item.
    #
    def sell_shop_item_tags_add(item_id, *tags, params)
      url = api_url "/sell/shop/items/#{item_id}/add_tags"
      load = {tag_list: tags.join(','), multipart: true}
      req = request_params({currency: @currency, locale: @locale}.merge(params))
      
      feed_or_retry do
        RestClient.post url, load, req
      end  
    end

    #
    # Remove one or more Tag to an Item.
    #
    def sell_shop_item_tags_remove(item_id, *tags, params)
      url = api_url "/sell/shop/items/#{item_id}/remove_tag"
      req = request_params({currency: @currency, locale: @locale}.merge(params))
      
      # with a hash sends parameters as a urlencoded form body
      load = {tag: tags.join(','), multipart: true}

      feed_or_retry do
        RestClient.post url, load, req
      end  
    end    


    #
    # Add an Item (:item_id) to a section (:section_name)
    #
    def sell_shop_item_section_add(item_id, section_name, params={})
      url = api_url "/sell/shop/items/#{item_id}/add_section"
      req = request_params({currency: @currency, locale: @locale}.merge(params))
      load = MultiJson.dump section: section_name

      feed_or_retry do
        RestClient.post url, load, req
      end  
    end 


    #
    # Remove an Item (:item_id) from a section (:section_id)
    #
    def sell_shop_item_section_remove(item_id, section_id, params={})
      url = api_url "/sell/shop/items/#{item_id}/remove_section/#{section_id}"
      req = request_params({currency: @currency, locale: @locale}.merge(params))
      
      feed_or_retry do
        RestClient.delete url, req
      end  
    end 

    #
    # SELL
    # SHOP_SECTIONS
    #

    #
    # Return all sections of current shop
    #
    def sell_shop_sections (params={})
      url = api_url "/sell/shop/sections"
      req = request_params(params)

      feed_or_retry do
        RestClient.get url, req
      end  
    end
  
    #
    # Creates a new section for current shop
    #
    def sell_shop_section_create (section_name, params={})
      url = api_url "/sell/shop/sections"
      req = request_params(params)
      load = MultiJson.dump name: section_name

      feed_or_retry do
        RestClient.post url, load, req
      end  
    end

    #
    # Update the section name from a given section_id of the current shop
    #
    def sell_shop_section_update (section_id, section_name, params={})
      url = api_url "/sell/shop/sections/#{section_id}"
      req = request_params(params)
      load = MultiJson.dump name: section_name

      feed_or_retry do
        RestClient.put url, load, req
      end  
    end

    #
    # Delete a section with a given section_id of the current shop
    # 
    def sell_shop_section_delete (section_id, params={})
      url = api_url "/sell/shop/sections/#{section_id}"
      req = request_params(params)

      feed_or_retry do
        RestClient.delete url, req
      end  
    end

    #
    # Returns an ordered, paginated list of all the items (pubished or not) 
    # present on a given shop section.
    #
    def sell_shop_section_items (section_id, params={})
      url = api_url "/sell/shop/sections/#{section_id}/items"
      req = request_params(params)

      feed_or_retry do
        RestClient.get url, req
      end  
    end

    #
    # SELL
    # SHOP_ORDERS
    #

    #
    # Returns the valid order states 
    # (for filtering purpose on API Orders requests).
    # This is a dictionary endpoint: it should never change 
    # and its response body may be long cached on API clients
    #
    def sell_shop_orders_states (params={})
      url = api_url "/sell/shop/orders/states"
      req = request_params(params)

      feed_or_retry do
        RestClient.get url, req
      end  
    end

    #
    # Returns a collection of orders received by the shop
    #
    def sell_shop_orders (order_status, params={})
      url = api_url "/sell/shop/orders"
      req = request_params({ order_status: order_status, currency: @currency, locale: @locale}.merge(params))

      feed_or_retry do
        RestClient.get url, req
      end  
    end

    #
    # Returns the details for the specific Order (uniquely identified by :order_number)
    #
    def sell_shop_orders_find (order_number, params={})
      url = api_url "/sell/shop/orders/#{order_number}"
      req = request_params(params)

      feed_or_retry do
        RestClient.get url, req
      end  
    end

    #
    # Cause a transaction in the Order state 
    # to the new state specified by state request param.
    #
    def sell_shop_orders_change_state (order_number, state, params={})
      url = api_url "/sell/shop/orders/#{order_number}/change_state"
      req = request_params({state: state}.merge(params))

      feed_or_retry do
        RestClient.post url, req
      end  
    end

    #
    # Foreward an Order cancellation request to Blomming staff.
    # The request parameter set MUST be passed into the request Body as a JSON object.
    #
    def sell_shop_orders_request_cancellation (order_number, reason_string, params={})
      url = api_url "/sell/shop/orders/#{order_number}/request_cancellation"
      req = request_params(params)
      load = MultiJson.dump reason: reason_string

      feed_or_retry do
        RestClient.post url, load, req
      end  
    end

    #
    # SELL
    # SHOP_SHIPPING_PROFILES
    #

    #
    # Returns all the shipping profiles of the shop.
    #
    def sell_shop_shipping_profiles (params={})
      url = api_url "/sell/shop/shipping_profiles"
      req = request_params({locale: @locale}.merge(params))

      feed_or_retry do
        RestClient.get url, req
      end  
    end

    #
    # SELL
    # SHOP_USER_DETAILS
    #

    # 
    # Get details about current user and his shop.
    #
    def sell_shop_user_details (params={})
      url = api_url "/sell/shop/user_details"
      req = request_params({locale: @locale}.merge(params))

      feed_or_retry do
        RestClient.get url, req
      end  
    end

  end
end