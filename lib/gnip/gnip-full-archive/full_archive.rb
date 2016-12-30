module Gnip
  module GnipFullArchive
    class FullArchive
    
      class InvalidRequestException < StandardError; end
      
      include HTTParty
      
      attr_reader :search_url, :counts_url
    
      #alias :total :total_entries
      
      def initialize(client)
        @search_url = "https://data-api.twitter.com/search/fullarchive/accounts/#{client.account}/#{client.label}.json"
        @counts_url = "https://data-api.twitter.com/search/fullarchive/accounts/#{client.account}/#{client.label}/counts.json"
        @auth = { username: client.username, password: client.password }
      end
          
      #Search using the fullarchive search endpoint return an hash containing up to 500 results and the cursor to the next page
      #options[:query] query to twitter
      #options[:per_page] default is 500
      #options[:start_date] as datetime
      #options[:end_date]  as datetime
      #options[:cursor_next] cursor to the next page
      def search(options = {})
        search_options = {}
        search_options[:query] = options[:query]||""
        search_options[:maxResults]  = options[:per_page]||500
        search_options[:fromDate]    = Gnip.format_date(options[:date_from]) if options[:date_from]
        search_options[:toDate]      = Gnip.format_date(options[:date_to]) if options[:date_to]
        search_options[:next]         = options[:next_cursor] if options[:next_cursor]  
        url = [self.search_url, search_options.to_query].join('?')
        begin
          gnip_call = self.class.get(url, basic_auth: @auth)
          response = gnip_call.response
          parsed_response = gnip_call.parsed_response
          parsed_response = (parsed_response||{}).with_indifferent_access
          raise response.message if !parsed_response.present?
          if parsed_response[:error].present?
            response = { results: [], next: nil, error: parsed_response[:error][:message], code: response.code.to_i }
          else
            response = { results: parsed_response[:results], next: parsed_response[:next], code: response.code.to_i }
          end
        rescue Exception => e
          response = { results: [], next: nil, error: e.message, code: 500 }
        end
        return response
      end
    
      # full aarchive search endpoints return total contents by day, minute, hour paginated
      # so to get totals across time period passed may need to run more than one call, the stop condition is cursor nil
      # bucket: must be one of [minute, hour, day]
      def total_by_time_period(options={})
        response = options[:response]||{}
        search_options = {}
        search_options[:query]    = options[:query]||""
        search_options[:bucket]   = options[:bucket]||'day'
        search_options[:fromDate] = Gnip.format_date(options[:date_from]) if options[:date_from]
        search_options[:toDate]   = Gnip.format_date(options[:date_to]) if options[:date_to]
        search_options[:next]     = options[:next_cursor] if options[:next_cursor]  
        url = [self.counts_url, search_options.to_query].join('?')
      
        begin
          gnip_call = self.class.get(url, basic_auth: @auth)
          response = gnip_call.response
          parsed_response = gnip_call.parsed_response
          parsed_response = (parsed_response||{}).with_indifferent_access
          raise response.message if !parsed_response.present?
          if parsed_response[:error].present?
            response = { results: [], next: nil, error: parsed_response[:error][:message], code: response.code.to_i }
          else
            parsed_response[:results].each_with_index do |item, i| 
              parsed_response[:results][i] = item.merge(timePeriod: DateTime.parse(item[:timePeriod]).to_s)
            end
            response = { results: (response[:results]||[]) + parsed_response[:results], next: parsed_response[:next], code: response.code.to_i }
          end
        rescue Exception => e
          response = { results: [], next: nil, error: e.message, code: 500 }
        end
        return response if !parsed_response[:next].to_s.present?
        total_by_time_period(query: search_options[:query], date_from: search_options[:fromDate], date_to: search_options[:toDate], bucket: search_options[:bucket], next_cursor: parsed_response[:next], response: response)
      end
  
      #return total contents in a specific date interval with a passed query 
      def total(options={})
        extra = {}
        response = total_by_time_period(options)
        extra = { error: response[:error] } if response[:error].present?
        return  { query: options[:query], total: response[:results].map{|item| item[:count]}.reduce(:+) }.merge!(extra)
      end
    
    end
  
  end
end
