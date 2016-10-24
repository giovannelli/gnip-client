module Gnip
  module GnipStream
    class Replay < Stream

      def initialize(client)
        super
        case self.version
        when '1.0'
          @url = "https://stream.gnip.com:443/accounts/#{client.account}/publishers/#{client.publisher}/replay/track/#{client.label}.json"
        when '2.0'
          @url = "https://gnip-stream.twitter.com/replay/powertrack/accounts/#{client.account}/publishers/#{client.publisher}/#{client.label}.json"
        else
          raise Exception.new("version #{self.version} is not supported from this gem.")
        end
      end
      
      def configure_handlers
        self.on_error { |error| @error_handler.attempt_to_reconnect("Gnip Connection Error. Reason was: #{error.inspect}") }
        self.on_connection_close { puts 'done' }
      end
          
      def consume(options={}, &block)
        @client_callback = block if block
        self.on_message(&@client_callback)
        self.connect(options)
      end
    
      def connect(options)
        search_options = {}
        search_options[:fromDate]    = Gnip.format_date(options[:date_from])  if options[:date_from]
        search_options[:toDate]      = Gnip.format_date(options[:date_to])    if options[:date_to]
        stream_url = [self.url, search_options.to_query].join('?')
        EM.run do
          http = EM::HttpRequest.new(stream_url, inactivity_timeout: 45, connection_timeout: 75).get(head: @headers)
          http.stream { |chunk| process_chunk(chunk) }
          http.callback { 
            handle_connection_close(http) 
            EM.stop
          }
          http.errback { 
            handle_error(http)
            EM.stop
          }
        end
      end
      
    end
  end
end