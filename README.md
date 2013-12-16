## About Blomming and Blomming API 

[Blomming](http://www.blomming.com) is an e-commerce marketplace I love! Why?

- Commercial policy for buyers and sellers clear&fair and above all cheap!
- [Support team](mailto:support@blomming.com) and [Editorial team](http://www.blomming.com/blog) really great! 
- It's yet another [Ruby on Rails](http://rubyonrails.org/) website successful story! 
- Last but not least, Blomming is "made in Italy"!

Now a rich set of APIs are available to developers, allowing to access almost all features of blomming kernel! Please refer to [Blomming API official Documentation](https://api.blomming.com/docs/v1/) for all details.


## Client side API Applications
Blomming API Application usage examples:

- specific third parties search engines (to retrieve shop items by keywords, categories, collections, tags, etc.)
- m-commerce / e-commerce custom apps (by example with API you can now build and android-based app "cloning" the www.blomming.com e-commerce for general purpose or specific mobile application)
- product catalogs data exchange between blomming database and thir party CMS (content management system). So you can quickly elaborate shop items data (add, remove, update, delete) with  batch procedures operating on huge amount of data. As proof of concept I wrote a script to export shop items into a CSV (comma separated values) file (see below `export_shop_items_to_csv.rb`).
- etc. 
- etc.

## blomming_api project @ github  

This project consist by:

1. The *blomming_api* rubygem source code, containing basic API client access helpers (the Blomming API wrapper kernel). Runtime available at the rubygems repository: https://rubygems.org/gems/blomming_api
2. The `endpoint.rb` script utility to quick test API endpoints
3. Some "demo" usage examples as ruby command line scripts, under: `/examples`


## Step 1: Install the *blommimg_api* gem !

Above all, install the gem:

    $ gem install blomming_api


## Step 2: Authentication set-up

In order to be granted to access to Blomming API, each client must be identified by some credential values (oauth server authentication). 

## Get your Blomming API credentials

API credentials are generated by Blomming tech team for a per 3rd part application use. Please contact [api@blomming.com](mailto:api@blomming.com) and explain briefly why do you need them and how do you plan to use Blomming service. Blomming tech team will be happy to give you the full access to API!

#### Buy Services Authentication

To access Blomming APIs, each client must be identified by two credential values required as parameters of initial Blomming OAuth server bearer token request:

- *Application ID*
- *Secret*

#### Sell Services Authentication

Application ID and Secret values, are all you need to use buy services, but in case of sell services, you must authenticate supplying also your Blomming account cusername and password:

- *Username*
- *Password*


### Set-up your *blommimg_api* configuration file 

Using the blomming_api gem, a client must be "initialized" with a YAML configuration file (.yml), in order to store all Blomming API credentials data and some default API values, among others:

- *domain* (production/staging API urls) 
- *api_version* (API release number)


You have to set-up all data on a blommimg_api YAML configuration file `<your_config_file.yml>`, following these two possible skeletons:

#### Config file for *BUY services* authentication
Config file example: `your/path/to/buy_services_stage_config.yml` :

```yaml
    client_app_description: my account for buy services, access to staging server 

    grant_type: client_credentials

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
    client_app_description: my account for sell services, access to production server  

    grant_type: password

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

## Step 3: Test endopoints with: `enpoint.rb`
You can quick test endpoints with the command line script utility `enpoint.rb`. The utility is self explanatory and let test basic behaviours, calling API endpoints with the minimum required parameters and using defaults parameters values. JSON data returned by endpoint is pretty printed on stdout.

    $ ruby endpoint.rb --help

	endpoint.rb (Blommimg API Endpoint Simple Tester)
	
	Usage:
	
	  ruby endpoint.rb <config_file.yml> <api_endpoint> [<parameters>]
	
	
	BLOMMING API Endpoint list and parameters:
	
	BUY
	
	  categories/index
	  categories/items <category_id>
	
	  collections/index
	  collections/items <collection_id>
	
	  countries
	
	  items/discounted
	  items/featured
	  items/hand_picked
	  items/list <item_id>
	  items/most_liked
	  items/search <keyword>
	
	  provinces/show <province_id>
	
	  shops/index
	  shops/items <shop_id>
	  shops/item  <shop_id> <item_id>
	  shops/show  <shop_id>
	
	  tags/index
	  tags/items <tag_id>
	
	  oauth_token
	
	Usage examples:
	
	  ruby endpoint.rb config.yml items/search "musica ambient"
	  ruby endpoint.rb config.yml shops/items solyarismusic
	  ruby endpoint.rb config.yml shops/item solyarismusic 552087
	  ruby endpoint.rb config.yml tags/items musica


## Step 4: Write your API Application!

As usage example, within the project (under `/examples` directory), I supplied some scripts. here below I list few:

### Example 1. Simplest API usage: `categories.rb`:  

Here a cli ruby script to get Blomming categories list (ITALY locale):

```ruby
	require 'blomming_api'
	
	if ARGV.empty?
	  puts "usage: #{$0} <config_file.yml>" 
	  exit
	else
	  config_file =  ARGV[0]
	end
		
	data = MultiJson.load BlommingApi::Client.new(config_file).categories_index ( {:locale => "it"} )
	
	data.each { |item| puts item["name"] }
```

	$ ruby categories_index.rb  ../config/solyarismusic.yml
	Arte:Altro
	Arte:Dipinti
	Arte:Fotografie
	Arte:Illustrazioni
	Arte:Sculture
	Arte:Stampe & Poster
	Casa:Antiquariato
	...	
	...
	Uomo:Abbigliamento
	Uomo:Accessori
	Uomo:Borse
	Uomo:Magliette
	Uomo:Orologi
	Uomo:Scarpe
	Uomo:Vintage

### Example 2. using all_pages method: `categories_items.rb`: 

The gem supply the method `all_pages` to retrieve all items of all pages of any API endpoint:

```ruby
	#!/bin/env ruby
	# encoding: utf-8
	require 'blomming_api'

	if ARGV[0].nil? || ARGV[1].nil?
	  puts "usage: #{$0} <config_file.yml> <category_name>" 
	  puts "example: ruby #{$0} ./config/yourconfig.yml \"Casa:Giardino & Outdoor\""
	  exit
	else
	  config_file = ARGV[0]
	  category_name = ARGV[1]
	end

	c = BlommingApi::Client.new config_file 

	# prende tutti i nomi delle categorie blomming
	categories_data = MultiJson.load c.categories_index

	# ottiene l'id associato a nome categoria (stringa)
	category_id = c.id_from_name category_name, categories_data

	unless category_id
	  puts "category name: #{category_name} not found among Blomming categories"
	  exit
	else
	  puts "searching items for category name: \"#{category_name}\" (category_id: #{category_id})"
	end	

	# estrae tutti gli items associati al category_id
	data = c.all_pages (true) { |page, per_page| c.categories_items( category_id, {:page => page, :per_page => per_page} ) } 

	data.each_with_index { |item, index| 
	  puts "#{index+1}: title: #{item["title"]}, id: #{item["id"]}, shop: #{item["shop"]["id"]}"
	}
```

	$ ruby categories_items.rb  ../config/solyarismusic.yml Uomo:Vintage
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


### Example 3. More complex client application: `export_shop_items_to_csv.rb`: 

Let say you want to export items of your shop into a CSV file!

	$ ruby export_shop_items_to_csv.rb --help
	
	export_shop_items_to_csv.rb v.0.0.3 by giorgio.robino@gmail.com
	
	  Export all items data from a specified Blomming shop (shop_id)
	  creating a CSV file (shop_id.csv), using API endpoint:
	
	    https://api.blomming.com/docs/v1/shops/items-GET.html
	
	  CSV file columns format:
	
	    id,title,description,created_at,price,original_price,photo1,photo2,photo3,photo4,quantity
	
	Usage:
	  $ ruby csv_export.rb config_file.yml [options]
	
	Examples:
	  $ ruby export_shop_items_to_csv.rb myconfig.yml -d --shop-id solyarismusic
	  $ ls solyarismusic.*
	  solyarismusic.csv  solyarismusic.json
	
	  $ ruby export_shop_items_to_csv.rb ./config/solyarismusic.yml  -s microregali -t '|'
	
	Options:
	                --shop-id, -s <s>:   shop_id, alias shop_name (default: solyarismusic)
	                      --debug, -d:   debug mode produce verbose log and generate JSON file with all data supplied by
	                                     API
	             --text-quote, -t <s>:   text column delimiter character in CSV file (default: ")
	                --col-sep, -c <s>:   columns delimiter character in CSV file (default: ,)
	  --output-directory-path, -p <s>:   directory path where create CSV and JSON output files (default: )
	                    --version, -v:   Print version and exit
	                       --help, -h:   Show this message


## To do

Possible priority list of actions to be completed: 

1. complete all endpoints (buy services endpoints are now implemented (90%) but most of "sell" services endpoints are still not implemented (10%)
2. Log file lack! maiinly to better manage Restclient exceptions return codes
3. write a "real-time" application using full REST approach, by example updating items in a shop and doing smart behaviours (by example a random/time scheduled price discount policy..., etc.)


## Licence

Feel free to do what you want with that source code.


## Thanks
- [Nicola Junior Vitto](https://github.com/njvitto), Blomming inventor and tech leader: he granted me to access APIs in prelease phase, and above all kindly supported me in my long mails about tests :-) 
- [Andrea Salicetti](https://github.com/knightq), part of Blomming tech team, for his support some Blomming API tricks
- Matteo, part of Blomming tech team, for his feedbacks about using multi_json
- [Paolo Montrasio](https://github.com/pmontrasio), my friend an ruby on rails guru, for his generous support about ruby language tips&tricks.


# Contacts

### API Credentials request
To get Blomming API credentials, please e-mail: [api@blomming.com](mailto:api@blomming.com)

### About me
I'm a sw developer, mainly using Ruby (on Rails) when I do server side programming. I'm also a mountaineer (loving white mountains) and a musician/composer: I realize sort of ambient music you can listen at [http://solyaris.altervista.org](http://solyaris.altervista.org). Since 2005 I gift and sell my music from my static old fashioned website but of course I have now my [solyaris music blomming shop](http://www.blomming.com/mm/solyarismusic/items) too and, just by joke, I used here some examples related to music and my shop_id: solyarismusic 

To get in touch about this github project, music, jobs, etc. e-mail me: [giorgio.robino@gmail.com](mailto:giorgio.robino@gmail.com)
