# encoding: utf-8
require 'multi_json'

module BlommingApi
  module PrivateHelpers
    #
    # build complete URL of any API request endpoint URI 
    #
    def api_url (api_endpoint_uri) 
	    "#{@domain}#{@api_version}#{api_endpoint_uri}"
    end  

  	#
    # return the hash to be used as HTTP header in all API requests,
    # embedding authentication token and all optional parameters
    # 
    def request_params(params={})
	    { authorization: "Bearer #{@access_token}", params: params }
    end

    #
    # feed_or_retry:
    # 
    # 1. call RestClient verb, 
    #    passed in a block (feed_or_retry is an iterator)
    #
    # 2. without any exception (http errors): 
    #    return data (convert response data from JSON to Ruby Hash)
    #
    # 2. in case of exceptions: 
    #    manage connection/RestClient exceptions 
    #    (by example retry the API call in case of authentication token expired). 
    #    
    #    In case of fatal error: 
    #      if @survive_on_fatal_error if false (default) 
    #         process die with exit  
    #      if @survive_on_fatal_error if true (must be specified in config file) 
    #         feed_or_retry return value: nil (no data available!).  
    #
    # === arguments
    #  
    #  &restclient_call_block
    #  the block to be passed (containing call to RestCient method)
    #
    # === examples
    #
    #  feed_or_retry { RestClient.get url, req }
    #
    def feed_or_retry (&restclient_call_block)
      begin
        # call RestClient verb
        json_data = restclient_call_block.call 

      # IP connection error, wrong url
      rescue SocketError => e
        socket_error! e
        retry

      # RestClient exceptions, manage HTTP status code
      rescue RestClient::Exception => e

        if http_status_code_401? e
          re_authenticate e
          retry

        elsif http_status_code_4xx? e
          return fatal_error! e

        elsif http_status_code_5xx? e 
          server_error! e
          retry

        # any other RestClient exception
        else
          return fatal_error! e
        end

      rescue => e
        return unknown_error! e

      else
        #
        # HTTP status 200: 
        # return 
        #  nil if there are no data!
        #  data as a Ruby hash (loaded from JSON)        
        (json_data.empty? || json_data.nil?) ? nil : (MultiJson.load json_data)
      end
    end


    # Client authentication failed due to unknown client, 
    # no client authentication included, 
    # or unsupported authentication method
    # After your bearer token has expired, 
    # each request done with that stale token will return an HTTP code 401
    def http_status_code_401?(e)
      401 == e.response.code 
    end  
    
    # 404: not found
    # 422: Invalid or blank request body given (sell services endpoints)
    def http_status_code_4xx?(e)
      [400, 404, 422].include? e.response.code 
    end  
    
    # possible temporary server problem ?
    def http_status_code_5xx?(e)
      [500, 520].include? e.response.code 
    end  

    #
    # Errors managers
    #
    def re_authenticate(e)
      STDERR.puts "#{Time.now}: HTTP status code: #{e.response.code}: #{e.response.body}. Invalid or expired token. Retry in #@retry_seconds seconds."

      # sleep maybe useless here
      sleep @retry_seconds

      #
      # Normal/expected behaviour with http status code == 401 
      # would be to authenticate with refresh token after the 401, so: 
      #
      # authenticate :refresh
      #
      # but in production sometime authentication with refresh token  
      # after an initial 401 bring to dead-end (getting 401 permanently), 
      #
      # so the agreed solution with Blomming tech team
      # have been to authenticate again from from scratch:
      # 
      authenticate :initialize
    end

    def server_error!(e)
      STDERR.puts "#{Time.now}: HTTP status code: #{e.response.code}: #{e.response.body}. Retry in #@retry_seconds seconds."
      
      sleep @retry_seconds
    end

    def socket_error!(e)
      STDERR.puts "#{Time.now}: socket error: #{e}. Possible net connection problems. Retry in #@retry_seconds seconds."
      
      sleep @retry_seconds
    end


    def fatal_error!(e)
      STDERR.puts "#{Time.now}: restclient error. http status code: #{e.response.code}: #{e.response.body}."
      
      #
      # survive_on_fatal_error initialized in config file  
      #
      unless @survive_on_fatal_error
        # Process die!
        exit
      else
        # no data!
        return nil
      end    
    end


    def unknown_error!(e)
      STDERR.puts "#{Time.now}: error: #{e.class}: #{e.message}"
      
      #
      # survive_on_fatal_error initialized in config file  
      #
      unless @survive_on_fatal_error
        # Process die!
        exit
      else
        # no data!
        return nil
      end    
    end
  end
end
