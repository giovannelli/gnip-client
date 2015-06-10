module Gnip
  module GnipRules
    class Rules
      
      include HTTParty
      
      attr_reader :rules_url
      
      def initialize(client)
        @rules_url = "https://api.gnip.com:443/accounts/#{client.account}/publishers/#{client.publisher}/streams/track/#{client.label}/rules.json"
        @auth = { username: client.username, password: client.password }
      end
      
      #Add rules to PowerTrack rules
      #rules should be an hash in the format {"rules": [{"value": "rule1", "tag": "tag1"}, {"value":"rule2"}]}"
      def add(rules)
        self.class.post(self.rules_url, basic_auth: @auth, body: rules.to_json)
      end
      
      #Remove rules from PowerTrack rules
      #rules should be an hash in the format {"rules": [{"value": "rule1", "tag": "tag1"}, {"value":"rule2"}]}"
      def remove(rules)
        self.class.delete(self.rules_url, basic_auth: @auth, body: rules.to_json)
      end
      
      #Get the full list of rules
      def list
        self.class.get(self.rules_url, basic_auth: @auth).parsed_response["rules"]
      end
      
      #delete all rules from PowerTrack
      def delete_all!
        rules = self.list.rules
        sleep 5
        self.remove(rules)
      end
    
    end
  end
end
