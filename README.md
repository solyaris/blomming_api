## About Blomming

[Blomming](http://www.blomming.com) is an e-commerce marketplace I love! because:

- Commercial approach for buyers and sellers is clear, fair, cheap
- [Support team](mailto:support@blomming.com) and [Editorial team](http://www.blomming.com/blog) really great
- It's yet another [Ruby on Rails](http://rubyonrails.org/) website successful application 
- Blomming is "made in Italy"

[![Blomming logo](http://www.blomming.com/images/mrfusion/logo-dark.png)](http://www.blomming.com)

### Blomming API

Now a rich set of APIs are available to developers, allowing to access almost all features of blomming kernel! Please refer to Blomming API official Documentation for details:

<p align="center">
  https://api.blomming.com/docs/v1/index.html
</p>

#### BUY/SELL API endpoints

You can access Blomming APIs with two different roles: as "buyer" or as "seller":

- *BUY Services* are a set of Blomming API endpoints that let you access to pretty *all* www.blomming.com features, as a "buyer" of web site could be: by example you can browse marketplace shops, get products details, do searches of specific products by tags, collections, etc. generally speaking in a "read only" way (so mainly with HTTPS GETs), but you can also create a shopping cart, adding products to the cart, put orders.  

- *SELL Services* are a different set of Blomming API endpoints that let you access data of *your* Blomming shop (the point of view of you seller). By example you can create, update, read, delete items in your shop, you can manage received orders, etc. etc.  

## This project  

Consist of:

1. The *blomming_api* rubygem code, containing basic API client access logic (the Blomming API wrapper layer). Runtime available at the [rubygems repository](http://rubygems.org/gems/blomming_api).

The idea behind the project is to supply some HTTP Blomming API wrapper/helpers to Ruby language applications developer. In the sketch here below the usual client / server architecture:  


					.-------------------------.
					|                         |
					|    Blomming website     |
					|       API Server        |
					|                         |
					.------------++-----------.
					             ^|
					             | < --- HTTPS request (+ JSON payload) (2)
					             || < -- JSON data response (3) 
					             ||
					             |v
					.-------------------------.
					|   blomming_api gem      | 
					| (Blomming API client)   |
					|                         |
					.------------++-----------.
					             ^| 
					   	         || < -- Ruby hash in/out data (4)
	                             | < --- endpoint method invocation (1) 
	                             |v
	                .------------++-----------.
	                |     CLI Application     |
	                | (long processing batch) |
					|                         |
					|            or           |
					|                         |				                              
                    |     Web Application     |
                    |   (Rails/Sinatra/etc.)  |
	                .-------------------------.


The blomming_api gem embed some authentication logic and encapsulate marshal/unmarshal JSON data (returned by server) to/from plain Ruby hash objects.

2. `/examples` contain some tests and demo usage examples as Ruby command line interface (CLI) scripts.


## Step 1: Install the *blommimg_api* gem ! [![Gem Version](https://badge.fury.io/rb/blomming_api.png)](http://badge.fury.io/rb/blomming_api)

Above all, install the gem:

    $ gem install blomming_api

gem install also the executable (now just showing basic gem info, but  in future releases the executable could supply online smart helps (endpoints usage/inspection, app generator):

    $ blomming_api


## Step 2: Authentication set-up

In order to be granted to access to Blomming API, each client must be identified by some credential values (oauth server authentication). 

### Get your Blomming API credentials

API credentials are generated by Blomming tech team for a per 3rd part application use. Please contact [api@blomming.com](mailto:api@blomming.com) and explain briefly why do you need them and how do you plan to use Blomming service. Blomming tech team will be happy to give you the full access to API!

#### BUY Services Authentication

To access Blomming APIs, each client must be identified by two credential values required as parameters of initial Blomming OAuth server bearer token request:

- *Application ID*
- *Secret*


#### SELL Services Authentication

Application ID and Secret values, are all you need to use *BUY services*, but in case of *SELL services*, you must authenticate supplying also your www.blomming.com account credentials:

- *Username*
- *Password*

Don't you have a Blomming Shop already ? Please [register](https://secure.blomming.com/account/new) and create your Blomming Shop!

### Set-up your *blommimg_api* configuration file 

Using the blomming_api gem, a client must be "initialized" with a YAML configuration file (.yml), in order to store all Blomming API credentials data and some default API values, among others:

- *domain* (production/staging API urls) 
- *api_version* (API release number)


You have to set-up all data on a blommimg_api YAML configuration file `<your_config_file.yml>`, following these two possible skeletons:

#### Config file for *BUY services* authentication
Config file example: `your/path/to/buy_services_stage_config.yml` :

```yaml
description: my account for buy services, access to staging server 

services: buy

client_id: __copy_here_your_blomming_api_client_id__
client_secret: __copy_here_your_blomming_api_client_secret__

domain: https://blomming-api-staging.herokuapp.com
api_version: /v1

default_currency: USD
default_locale: US

verbose: false
```

#### Config file for *SELL services* authentication
Config file example `your/path/to/buy_services_prod_config.yml`:

```yaml
description: my account for sell services, access to production server  

services: sell

client_id: __copy_here_your_blomming_api_client_id__
client_secret: __copy_here_your_blomming_api_client_secret__

username: __copy_here_your_blomming_account_username__
password: __copy_here_your_blomming_account_password__

domain: https://api.blomming.com
api_version: /v1

default_currency: EUR
default_locale: it

verbose: true 
```

## Step 3: Test endpoints with examples scripts
You can quick test endpoints with some command line script utilities in directories:

- `examples/endpoints/buy/*.rb`
- `examples/endpoints/sell/*.rb`

As example of Blomming_api gem usage, I supplied some scriptswithin the project (under `/examples` directory). Here below I list few of them:

### Example 1. Simplest API usage: `categories.rb`:  

Here a cli ruby script to get Blomming categories list (country locale: ITALY):

```ruby
	require 'blomming_api'
	
	puts "usage: #{$0} <config_file.yml>" and exit if ARGV.empty?
    config_file =  ARGV[0]
		
	categories = BlommingApi::Client.new(config_file).categories locale: "it"
	
	categories.each { |item| puts item["name"] }
```

	$ ruby categories_index.rb  myconfig.yml
	Arte:Altro
	Arte:Dipinti
	Arte:Fotografie
	Arte:Illustrazioni
	Arte:Sculture
	Arte:Stampe & Poster
	Casa:Antiquariato
	...	
	...

### Example 2. using all_pages method: `categories_items.rb`: 

The gem supply the helper method `all_pages` to retrieve all items of all pages of any API endpoint:

```ruby
	require 'blomming_api'

	if ARGV[0].nil? || ARGV[1].nil?
	  puts "usage: #{$0} <config_file.yml> <category_name>" 
	  puts "example: ruby #{$0} yourconfig.yml \"Casa:Giardino & Outdoor\""
	  exit
	end
	
	config_file = ARGV[0]
	category_name = ARGV[1]
	
	c = BlommingApi::Client.new config_file 

	# retrieve all blomming categories names 
	categories = c.categories

	# get id (numeric identificator) associated to a certain category name (string identificator)
	category_id = c.id_from_name category_name, categories

	unless category_id
	  puts "category name: #{category_name} not found among Blomming categories"
	  exit
	else
	  puts "searching items for category name: \"#{category_name}\" (category_id: #{category_id})"
	end	

	# retrieve all items data associated to a category
	all_items = c.all_pages do |page, per_page| 
	  c.categories_items( category_id, {page: page, per_page: per_page} )
	end   

    # for each item: print on stdout a subset of data fields (item title, item id, shop id)
	all_items.each_with_index do |item, index| 
	  puts "#{index+1}: title: #{item["title"]}, id: #{item["id"]}, shop: #{item["shop"]["id"]}"
	end
```

	$ ruby categories_items.rb  myconfig.yml Uomo:Vintage
	searching items for category name: "Uomo:Vintage" (category_id: 113)
	collecting items from pages ....................
	1: title: Orologio Seiko vintage, id: 625777, shop: Artivoquadri
	2: title: 80s Turtleneck Biker Polo, id: 621376, shop: MadCappuccino
	3: title: joe petrosino , id: 621082, shop: otticaservice
	4: title: exess 1793, id: 621077, shop: otticaservice
	5: title: logonò 39,00 €, id: 620489, shop: otticaservice
	6: title: camicia LoonyShirt Hypnotic One, id: 619139, shop: beloony
	...
	...


### Example 3. A bit more complex client application: `shop_items_dump_csv.rb`: 

Let say you want to export items of your shop into a CSV file!
A simple command line interface script to dump shop items here:

`/examples/applications/shop_items_csv_file/shop_items_dump_csv.rb`


## Step 4: Write your client API Application!

Blomming API Application usage examples and some ideas here:

### BUY Services applications

- specific third parties "search engines" (to retrieve shop items by keywords, categories, collections, tags, etc.)
- m-commerce / e-commerce custom apps. By example you can realize android-based apps "cloning" the www.blomming.com e-commerce for general purpose thematic marketplaces or specific mobile applications.

### SELL Services applications

- product catalogs data exchange between blomming database and thir party CMS (content management system). So you can quickly elaborate shop items data (add, remove, update, delete) with  batch procedures operating on huge amount of data. As proof of concept I wrote a script to export shop items into a CSV (comma separated values) file (see below `shop_items_dump_csv.rb`).
- real-time shop orders management, by example polling incoming orders status to dispatch "new order" messages to seller.
- real-time shop items management, by example updating with creativity items attributes in a shop and doing crazy marketing behaviours, like a time-scheduled (or random periods) price "sauvage" discount policy (on certain collection of a shop items)!
- etc. etc.

## Release Notes

IMPORTANT:

Blomming_api gem (and usage examples in this github project) are now in a "prerelease" phase; many todo tasks need to be completed (I'll publish a more stable release by January 2014).

### v.0.3.11
- Prerelease: 30 December 2013
- buy endpoints: completed! Carts endpoints must be verified with blomming tech team.
- sell endpoints: almost completed. Orders/Shipping Profiles endpoints must be verified with blomming tech team.
- `blomming_api -e` executable: -e option give info about buy/sell endpoints methods.

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

- Supply methods to fully cover Blomming API endpoints (all *buy* services endpoints are now implemented (100%) but many of *sell* services endpoints are still to be implemented (50%).
- Realize a test framework. 
- Refactor classes architecture: now endpoints return Ruby hashes translating one-to-one JSON returned by HTTP API calls. Naif, I admit! A possible alternative implementation (v.2.0) is to create a specific Resource class for every Blomming resource (Category, Order, Shop, Item, Sku, etc.), I'll possibly investigate how to use/sublclass ActiveResource, or a similar approach.
- BLOMMING_API::Client.load_and_retry() method is debatable. Better manage Restclient exceptions return codes. Sleep() on retry it's a bad solution for client running as Web app, so probably a non-blocking thread architecture could be the correct way. Subclass for different behaviours on exceptions.  
- Do some Log file logic for debug. 


## Licence

Feel free to do what you want with that source code.


## Special Thanks
- [Nicola Junior Vitto](https://github.com/njvitto), Blomming founder and tech leader: he granted me to access APIs in prelease phase, and above all kindly supported me in my long mails about tests :-) 
- [Andrea Salicetti](https://github.com/knightq), member of Blomming tech team, for his support some Blomming API explanantions
- [Matteo Parmi](https://github.com/tejo), member of Blomming tech team, for his feedback about multi_json
- [Paolo Montrasio](https://github.com/pmontrasio), my friend and Ruby on Rails guru, for his generous support about Ruby language tips&tricks.


# Contacts

### API Credentials request
To get Blomming API credentials, please e-mail: [api@blomming.com](mailto:api@blomming.com)

### About me
I develop mainly using Ruby (on Rails) when I do server side programming. I'm also a mountaineer (loving white mountains) and a musician/composer: I realize sort of ambient music you can listen and download at [http://solyaris.altervista.org](http://solyaris.altervista.org). Of course I have now my [solyaris music blomming shop](http://www.blomming.com/mm/solyarismusic/items) and, just by joke, I used here some examples related to music and my blomming shop (id: solyarismusic). 

Please let me know, criticize, contribute with ideas or code, feel free to write an e-mail with your thoughts! and of you like the project, a github STAR is always welcome :-) To get in touch about this github project, music, jobs, etc. e-mail me: [giorgio.robino@gmail.com](mailto:giorgio.robino@gmail.com)
