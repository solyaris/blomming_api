<p align="center">
  <img src="http://www.blomming.com/images/mrfusion/header/logo.png" alt="Blomming logo">
</p>

## What Blomming is

[Blomming](http://www.blomming.com) is an e-commerce marketplace I love! because:

- Social e-commerce with clear, fair, cheap approach for both Buyers and Sellers
- [Support team](mailto:support@blomming.com) and [Editorial team](http://www.blomming.com/blog) really great; (about technical team, see thanks paragraph)!
- It's yet another [Ruby on Rails](http://rubyonrails.org/) website successful application 
- Blomming is "made in Italy"


### Blomming API

Now a rich set of APIs are available to developers, allowing to access almost all features of blomming kernel! Please refer to Blomming API official Documentation for details:

<p align="center">
  https://api.blomming.com/docs/v1/index.html
</p>

#### BUY/SELL API endpoints

You can access Blomming APIs with two different roles: as "buyer" or as "seller":

- *BUY Services* are a set of Blomming API endpoints that let you access to pretty all www.blomming.com features, as a *buyer* of web site could be: by example you can browse marketplace shops, get products details, do searches of specific products by tags, collections, etc. generally speaking in a "read only" way, but you can also create a shopping cart, adding products to the cart, put orders; all in all you can do all a buyer do at www.blomming.com/buy   

- *SELL Services* are a different set of Blomming API endpoints that let you access data of *your one* Blomming shop (the point of view of you *seller*). By example you can create, update, read, delete items in your shop, you can manage received orders, etc. etc.  

## This project  

Consist of:

1. The *blomming_api* rubygem code, containing basic API client access logic (the Blomming API wrapper layer). Gem available at the [rubygems repository](http://rubygems.org/gems/blomming_api).

2. [`/examples`](https://github.com/solyaris/blomming_api/tree/master/examples) contains some tests and demo usage examples as Ruby command line interface (CLI) scripts.


The idea behind the project is to supply some HTTP Blomming API wrapper/helpers to Ruby language applications developer, wrapping multipart/form-data or JSON payload encoding with Ruby hashes data structures. In the sketch here below the usual client / server architecture:  


					.-------------------------.
					|    Blomming website     |
					|       API Server        |
					.------------++-----------.
					             ^|
					             | < --- HTTPS request (+ JSON payload) (2)
					             || < -- JSON data response (3) 
					             ||
					             |v
					.-------------------------.
					|   blomming_api gem      | 
					| (Blomming API client)   |
					.------------++-----------.
					             ^| 
					   	         || < -- Data in/out as Ruby hashes (4)
	                             | < --- endpoint method invocation (1) 
	                             |v
	                .------------++-----------.
	                |     CLI Application     |
	                |  (long-running script)  |
					|            or           |
                    |     Web Application     |
                    |   (Rails/Sinatra/etc.)  |
	                .-------------------------.


The blomming_api gem embeds some authentication logic and encapsulates marshal/unmarshal JSON data (returned by server) to/from plain Ruby hash objects.


## Step 1: Install the *blommimg_api* gem ! [![Gem Version](https://badge.fury.io/rb/blomming_api.png)](http://badge.fury.io/rb/blomming_api)

Above all, install the gem:

    $ gem install blomming_api

gem installs also the executable (now just showing basic gem info, but  in future releases the executable could supply online smart helps (endpoints usage/inspection, app generator):

    $ blomming_api


Install all source code use Git to clone the blomming_api for Ruby project from GitHub:

	$ git clone https://github.com/solyaris/blomming_api.git

Edit configurations files:

    $ cd blomming_api/config

Edit examples:

    $ cd blomming_api/examples


## Step 2: Authentication set-up

In order to be granted to access to Blomming API, each client must be identified by some credentials values (for oauth server authentication). 

### Get your Blomming API credentials

API credentials are generated by Blomming tech team for a per 3rd part application use. Please contact [api@blomming.com](mailto:api@blomming.com) and explains briefly why do you need them and how do you plan to use Blomming service. Blomming tech team will be happy to give you the full access to API!

#### BUY Services Authentication

To access Blomming APIs, each client must be identified by two credentials values required as parameters of initial Blomming OAuth server bearer token request:

- *Application ID*
- *Secret*


#### SELL Services Authentication

Application ID and Secret values, are all you need to use *BUY services*, but in case of *SELL services*, you must authenticate supplying also your www.blomming.com account credentials:

- *Username* (it's the *shop id*)
- *Password* (the password you registered at Blomming when you created your shop)

Don't you have a Blomming Shop already ? Please [register](https://secure.blomming.com/account/new) and create your Blomming Shop!

### Set-up your *blommimg_api* configuration file 

Using the blomming_api gem, a client must be initialized with a YAML configuration file (.yml), in order to store all Blomming API credentials data and some default API values, among others:

- *domain* (production/staging API urls) 
- *api_version* (API release number)

You have to set-up all data on a blommimg_api YAML configuration file `<your_config_file.yml>`, following these two possible skeletons:

#### Config file for *BUY services* authentication
Config file example: [`your/path/to/config/buy_services_stage_config.yml`](https://github.com/solyaris/blomming_api/blob/master/config/buy_services_example.yml) (excerpt):

```yaml
description: my account for buy services, access to staging server 

services: buy

client_id: __copy_here_your_blomming_api_client_id__
client_secret: __copy_here_your_blomming_api_client_secret__

domain: https://blomming-api-staging.herokuapp.com
api_version: /v1
```

#### Config file for *SELL services* authentication
Config file example [`your/path/to/config/buy_services_prod_config.yml`](https://github.com/solyaris/blomming_api/blob/master/config/sell_services_example.yml) (excerpt):

```yaml
description: my account for sell services, access to production server  

services: sell

client_id: __copy_here_your_blomming_api_client_id__
client_secret: __copy_here_your_blomming_api_client_secret__

username: __copy_here_your_blomming_account_username__
password: __copy_here_your_blomming_account_password__

domain: https://api.blomming.com
api_version: /v1
```

BTW, To easy config file access you can set the environment variable:  

	$ export CONFIG=/your/home/path/config/yourconfig.yml


## Step 3: Test endpoints

You can quick test endpoints with some command line script utilities in directories:

- `examples/endpoints/buy/*.rb`
- `examples/endpoints/sell/*.rb`

As example of Blomming_api gem usage, I supplied some scripts within the project (under `/examples` directory). Here below I list few of them:

###  Endpoint Test Example. Simplest API usage:  

Here a ruby script ( `/examples/enspoints/buy/categories.rb` ) to get Blomming categories list (country locale: ITALY):

```ruby
require 'blomming_api'

if ARGV.empty?
  puts " goal: test endpoint: categories"
  puts "usage: #{$0} <config_file.yml>"
  exit 
end

config_file =  ARGV[0]

# client initialize (authenticate to server)
blomming = BlommingApi::Client.new config_file

# get categories, for country locale: ITALY
categories = blomming.categories locale: "IT"

# list categories on stdout 
categories.each { |item| puts item["name"] }
```

Let's run the script:

	$ ruby categories_index.rb $CONFIG
	Arte:Altro
	Arte:Dipinti
	Arte:Fotografie
	Arte:Illustrazioni
	Arte:Sculture
	Arte:Stampe & Poster
	Casa:Antiquariato
	...	
	...


### Endpoint Test Example. Shop Item Create,Read,Update,Delete: 

Here an example ( excerpt from: [`/examples/endpoints/sell/sell_shop_items_crud.rb`](https://github.com/solyaris/blomming_api/blob/master/examples/endpoints/sell/sell_shop_items_crud.rb) ) of *sell* endpoints to do CRUD operations on items of a shop. The script list all items of a shop, using the helper method `all_pages` (that retrieves all items of all pages of any API endpoint). Afterward a new item is created, updated, read again and deleted.

```ruby
# here just an excerpt
# read full code at: `/examples/endpoints/sell/sell_shop_items_crud.rb`

c = BlommingApi::Client.new config_file

# shop_id == username
shop_id = c.username

# CREATE NEW ITEM
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

puts "creating new item, shop: #{shop_id} ..."

response = c.sell_shop_item_create new_item

```

### Application example 1: Export shop items to a CSV file 

Let say you want to export items of your shop into a CSV file!
A simple command line interface script to dump shop items here:

`/examples/applications/shop_items_export_to_CSV/shop_items_dump_csv.rb`

Please note the application is just a demo, to be completed to manage all data as tags and sections (to mentions few). 

### Application example 2: Discounts shop items

Let say you want to discount prices of some shop items, with a batch procedure! let see script `/examples/applications/shop_items_discounts/sell_shop_set_discounts.rb`:

	$ ruby sell_shop_set_discounts.rb $CONFIG
	   goal: discount price for a specified set of items on the shop
	  usage: sell_shop_set_discounts.rb <config_file.yml> <discount_percentage> [<item_id>]
	example:ruby sell_shop_set_discounts.rb solyarismusic.yml 10% 540268 540266

	$ ruby sell_shop_set_discounts.rb $CONFIG 10% 540268 540266
	items to be discounted for shop 'solyarismusic':
	            id: 540268
	         title: Western Detunes (cdr)
	      currency: EUR
	         price: 12.0
	original price:

	            id: 540266
	         title: Mellow Stasis – Complete Edition (double cdr)
	      currency: EUR
	         price: 22.0
	original price:

	retrieving item: 540268
	discounting item with new price: 10.8
	(original price: 12.0, discount percentage: 10%)
	successfully discounted item: 540268!

	retrieving item: 540266
	discounting item with new price: 19.8
	(original price: 22.0, discount percentage: 10%)
	successfully discounted item: 540266!

### Application example 3: SMS Orders Notifier

A possibly useful application is a long-running task to notify new orders of your Blomming shop, sending SMS in real-time. To send SMS I used [Skuby](https://github.com/welaika/skuby) gem to interface [Skebby](http://www.skebby.com) cheap and affordable SMS Gateways services provider.

<p align="center">
  <img src="http://static.skebby.it/s/i/sms-gratis-business.png" alt="skebby logo"> 
</p>

The script has a very simple approach (single process, single thread, that poll every n seconds the Blomming Api Server). Here below the main Ruby procedure `/examples/applications/shop_orders_notifier/orders_notifier.rb` :

```ruby
require_relative '_orders_notifier'

# connect to Blomming API server
blomming = initialize_all

# every n seconds fetch new orders from Blomming API sever, 
# and notify via SMS to Seller.
schedule_every @poll_seconds do
  new_orders_from blomming do |client, order|

    # notify with a SMS each new order!
    notify_sms client, order

  end
end
```

Instant gratification! see log of long-running process running when the shop have two new orders; please note SMS text messages contain order number and all data sufficient to process order and possibly keep in touch on the fly with Buyer (having his mobile phone in the SMS)! 

```
$ ruby  orders_notifier.rb $CONFIG
SMS Order Notifier for Blomming, release: 1 February 2014, by: giorgio.robino@gmail.com
CTRL+C to stop
02-02-2014 21:53:46: Successfully connected with Blomming API Server, for shop: solyarismusic
02-02-2014 21:53:50: NEW ORDER: 3bba016d12ed0a99 (num products: 0, price: 9.0 EUR, current state: to_ship_not_paid)
02-02-2014 21:53:55: SMS SENT:
NEW ORDER 3bba016d12ed0a99
1 PIZZA QUATTRO STAGIONI
1 PIZZA MARGHERITA
TOT 9.0EUR
Paola Pitagora
via Gramsci 2R, Genova
3900000000

02-02-2014 21:53:55: NEW ORDER: f3b59fd95eee17e1 (num products: 0, price: 4.0 EUR, current state: to_ship_not_paid)
02-02-2014 21:54:00: SMS SENT:
NEW ORDER f3b59fd95eee17e1
1 PIZZA MARGHERITA
TOT 4.00EUR
Anna Maria Rosina
Via 25 Aprile 4/2, Genova
3911111111

^Corders_notifier.rb has ended (crowd applauds)
```


## Step 4: Write your client API Application!

Blomming API Application usage examples and some ideas here:

### BUY Services applications

- specific third parties "search engines" (to retrieve shop items by keywords, categories, collections, tags, etc.)
- m-commerce / e-commerce custom apps. By example you can realize android-based apps "cloning" the www.blomming.com e-commerce for general purpose thematic marketplaces or any specific mobile applications.

### SELL Services applications

- product catalogs data exchange between blomming database and third party CMS (content management system). So you can quickly elaborate shop items data (add, remove, update, delete) with  batch procedures operating on huge amount of data. As proof of concept I wrote a script to export shop items into a CSV (comma separated values) file (see in examples the script: `shop_items_dump_csv.rb`).
- real-time shop orders management, see by example my application that notifying "new orders" messages to Seller, dispatching SMS alerts, or forward well formatted e-mails to *shop manager*.
- real-time shop items management, by example updating with creativity items attributes in a shop and doing crazy marketing behaviours, like a time-scheduled (or random periods) *"sauvage" price discount policy* (on certain collection of a shop items) / creating *Temporary Stores*, using *sections*!
- Many other e-commerce creative ideas!

## Release Notes

IMPORTANT:

Blomming_api gem (with usage examples in this github project) is now in a "prerelease" phase; many todo tasks need to be completed in synch to Blomming Server API updates (February 2014).

### v.0.6.1
- Prerelease: 04 February 2014
- *Sections* endpoints added.
- Application example "SMS Order notifier" now available!

### v.0.5.2
- Prerelease: 20 January 2014
- timestamp conversions helpers added (iso8601 to local time).
- "Sections" (Sell endpoints), added.
- *Tags* add/remove (Sell endpoints) fixed.
- *Shipping Profiles* (Sell endpoints) fixed, but must be verified with blomming tech team.
- *Carts* (Buy endpoints) updated with correct multipart/form-data payload encoding (test script: `carts.rb`). To be verified with blomming tech team.  
- `blomming_api -e` executable now give better info about public endpoints methods!

### v.0.4.4
- Prerelease: 6 January 2014
- config file examples: comments inside
- A bit better exceptions handling in feed_or_retry method
- *Buy* endpoints: completed.
- *Sell* endpoints: completed.


### v.0.3.3
- Prerelease: 23 December 2013
- All endpoints methods correctly return Ruby hashes 
- Authentication logic adjusted
- Code refactored with better usage of modules
- Examples directory hierarchy modified
- `blomming_api` executable added in gem

### v.0.1.0
- First release: 17 December 2013


## To do

- YAML Config file with username/password in clear (not encrypted) is not a good solution for security reason. Find a better solution (encrypt sensitive credentials/ manage ENV vars).  
- Refactor classes architecture: now endpoints return Ruby hashes translating one-to-one JSON returned by HTTP API calls. Naif, I admit! A possible alternative implementation (v.2.0) is to create a specific *Resource* class for every Blomming resources (Category, Order, Shop, Item, Sku, etc.), I'll possibly investigate how to use/sublclass ActiveResource, or to use a similar approach.
- BlommingApi::Client.feed_and_retry() method is debatable. Better manage Restclient exceptions return codes. Sleep() on retry it's a bad solution for client running as Web app, so probably a non-blocking thread architecture could be the correct way. Subclass for different behaviours on exceptions.
- Manage BlommingApi::Client last endpoint status/exception.  
- Realize a serious Unit Test framework. 
- Do some Log file logic for debug. 


## License (MIT)

Copyright (c) 2014 Giorgio Robino

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


## Special Thanks
- [Nicola Junior Vitto](https://github.com/njvitto), Blomming founder and tech leader: he granted me to access APIs in prelease phase, and above all kindly supported me in my long mails about tests :-) 
- [Andrea Salicetti](https://github.com/knightq), member of Blomming tech team, for his support some Blomming API explanantions
- [Matteo Parmi](https://github.com/tejo), member of Blomming tech team, for his feedback about multi_json
- [Paolo Montrasio](https://github.com/pmontrasio), my friend and Ruby on Rails guru, for his generous support about Ruby language tips&tricks.
- [Fabrizio Monti](https://github.com/welaika), for his smart [Skuby](https://github.com/welaika/skuby) gem to send SMS with Skebby.
- [Peter Ohler](https://github.com/ohler55), for his superb gems: Oj (fast JSON parser used in this project behind MultiJson) and Ox (fast XML parser).


# Contacts

### API Credentials request
To get Blomming API credentials, please e-mail: [api@blomming.com](mailto:api@blomming.com)

### About me
I'm a freelance Ruby developer. I'm also a musician/composer, realizing sort of ambient music you can listen/download at [http://solyaris.altervista.org](http://solyaris.altervista.org). Of course I have now my [solyaris music blomming shop](http://www.blomming.com/mm/solyarismusic/items) and, just as proof-of-concept, I used here some examples related to music and my blomming shop (id: solyarismusic). 

Please let me know, contribute with ideas or code, feel free to write an e-mail with your thoughts! To get in touch about this github project,jobs proposals! Anyway if you like the project, a github STAR is always welcome :-) 

e-mail me: [giorgio.robino@gmail.com](mailto:giorgio.robino@gmail.com)
