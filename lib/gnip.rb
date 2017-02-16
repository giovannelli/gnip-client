require 'active_support/core_ext/hash'
require 'httparty'
require 'gnip/version'
require 'gnip/power_track_client'
require 'gnip/gnip-rules/rules'
require 'gnip/gnip-full-archive/full_archive'
require 'gnip/gnip-stream/error_reconnect'
require 'gnip/gnip-stream/json_data_bufffer'
require 'gnip/gnip-stream/stream'
require 'gnip/gnip-stream/replay'

begin
  require "pry"
rescue LoadError => e
  
end

module Gnip
  
  def self.format_date(datetime)
    datetime.to_datetime.utc.strftime('%Y%m%d%H%M')
  end
  
end
