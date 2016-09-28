require 'eventmachine'
require 'em-http-request'

module Gnip
  module GnipStream
    class Stream
    
      EventMachine.threadpool_size = 5

      attr_accessor :url, :backfill_client, :version

      def initialize(client)
        self.version = client.power_track_version
        case self.version
        when '1.0'
          @url = "https://stream.gnip.com:443/accounts/#{client.account}/publishers/#{client.publisher}/streams/track/#{client.label}.json"
        when '2.0'
          @url = "https://gnip-stream.twitter.com/stream/powertrack/accounts/#{client.account}/publishers/#{client.publisher}/#{client.label}.json"
        else
          raise Exception.new("version #{self.version} is not supported from this gem.")
        end
        @backfill_client = client.backfill_client
        @processor  = JsonDataBuffer.new("\r\n", Regexp.new(/^\{.*\}\r\n/))
        @headers    = {'authorization' => [client.username, client.password], 'accept-encoding' => 'gzip, compressed'}
        @error_handler = ErrorReconnect.new(self, :consume)
        @connection_close_handler = ErrorReconnect.new(self, :consume)
        configure_handlers
      end
    
      def configure_handlers
        self.on_error { |error| @error_handler.attempt_to_reconnect("Gnip Connection Error. Reason was: #{error.inspect}") }
        self.on_connection_close { @connection_close_handler.attempt_to_reconnect("Gnip Connection Closed") }
      end

      def consume(&block)
        @client_callback = block if block
        self.on_message(&@client_callback)
        self.connect
      end
    
      def on_message(&block)
        @on_message = block
      end

      def on_connection_close(&block)
        @on_connection_close = block
      end

      def on_error(&block)
        @on_error = block
      end

      def connect
        EM.run do
          options = {}
          options = { query: { "client" => self.backfill_client } } if self.backfill_client.present?
          http = EM::HttpRequest.new(self.url, inactivity_timeout: 45, connection_timeout: 75).get( { head: @headers }.merge!(options))
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

      def process_chunk(chunk)
        @processor.process(chunk)
        @processor.complete_entries.each do |entry|
          EM.defer { @on_message.call(entry) }
        end
      end

      def handle_error(http_connection)
        @on_error.call(http_connection)
      end

      def handle_connection_close(http_connection)
        @on_connection_close.call(http_connection)
      end

    end
  end
end