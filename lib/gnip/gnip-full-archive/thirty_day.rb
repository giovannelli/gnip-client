# frozen_string_literal: true

module Gnip
  module GnipFullArchive
    class ThirtyDay < FullArchive

      def initialize(client)
        @search_url = "https://data-api.twitter.com/search/30day/accounts/#{client.account}/#{client.label}.json"
        @counts_url = "https://data-api.twitter.com/search/30day/accounts/#{client.account}/#{client.label}/counts.json"
        @auth = { username: client.username, password: client.password }
      end

    end
  end
end
