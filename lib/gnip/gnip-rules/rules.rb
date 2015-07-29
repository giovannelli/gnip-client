module Gnip
  module GnipRules
    class Rules
      
      include HTTParty
      
      attr_reader :rules_url
      
      def initialize(client, replay=false)
        @rules_url = "https://api.gnip.com:443/accounts/#{client.account}/publishers/#{client.publisher}/#{replay ? "replay" : "streams"}/track/#{client.label}/rules.json"
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
        self.class.get(self.rules_url, basic_auth: @auth).parsed_response.slice("rules")
      end
      
      #delete all rules from PowerTrack
      #http://support.gnip.com/apis/powertrack/api_reference.html#DeleteRules
      #Request Body Size Limit 1 MB (~5000 rules)
      def delete_all!
        rules_list = self.list
        rules_list["rules"].in_groups_of(2, false).each do |group_of_rules|
          self.remove({ "rules": group_of_rules })
        end
        sleep 0.05
        rules_list = self.list
        if !rules_list["rules"].size.zero?
          self.delete_all!
        else
          return []
        end
      end
    end
    
  end
end
