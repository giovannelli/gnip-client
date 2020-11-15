# frozen_string_literal: true

module Gnip
  module GnipRules
    class Rules
      include HTTParty

      attr_reader :rules_url, :version

      def initialize(client, replay = false)
        @version = client.power_track_version
        case version
        when '1.0'
          @rules_url = "https://api.gnip.com:443/accounts/#{client.account}/publishers/#{client.publisher}/#{replay ? 'replay' : 'streams'}/track/#{client.label}/rules.json"
        when '2.0'
          if replay
            @rules_url = "https://gnip-api.twitter.com/rules/powertrack-replay/accounts/#{client.account}/publishers/#{client.publisher}/#{client.replay_label}.json"
          else
            @rules_url = "https://gnip-api.twitter.com/rules/powertrack/accounts/#{client.account}/publishers/#{client.publisher}/#{client.label}.json"
          end
        else
          raise Exception, "version #{version} is not supported from this gem."
        end
        @auth = { username: client.username, password: client.password }
      end

      # Add rules to PowerTrack rules
      # rules should be an hash in the format {"rules": [{"value": "rule1", "tag": "tag1"}, {"value":"rule2"}]}"
      def add(rules)
        response = self.class.post(rules_url, basic_auth: @auth, body: rules.to_json, headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }, type: :json)
        parsed_response = safe_parsed_response(response.parsed_response)
        if parsed_response.present? && parsed_response['error'].present?
          { status: :error, code: response.response.code, error: parsed_response['error']['message'] }
        else
          { status: :success, code: 200, response: parsed_response }
        end
      rescue Exception => e
        { status: :error, code: 500, error: e.message }
      end

      # Remove rules from PowerTrack rules
      # rules should be an hash in the format {"rules": [{"value": "rule1", "tag": "tag1"}, {"value":"rule2"}]}"
      def remove(rules)
        response = self.class.post(rules_url, query: { _method: 'delete' }, basic_auth: @auth, body: rules.to_json)
        parsed_response = safe_parsed_response(response.parsed_response)
        if parsed_response.present? && parsed_response['error'].present?
          { status: :error, code: response.response.code, error: parsed_response['error']['message'] }
        else
          { status: :success, code: 200, response: parsed_response }
        end
      rescue Exception => e
        { status: :error, code: 500, error: e.message }
      end

      # Get the full list of rules
      def list
        response = self.class.get(rules_url, basic_auth: @auth, headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }, type: :json)
        parsed_response = safe_parsed_response(response.parsed_response)
        if parsed_response.present? && parsed_response['error'].present?
          { status: :error, code: response.response.code, error: parsed_response['error']['message'] }
        else
          { status: :success, code: 200, rules: parsed_response['rules'] }
        end
      rescue Exception => e
        { status: :error, code: 500, error: e.message }
      end

      # Get the full list of rules by tag
      def list_by_tag(tag)
        response = self.class.get(rules_url, basic_auth: @auth)
        parsed_response = safe_parsed_response(response.parsed_response)
        if parsed_response.present? && parsed_response['error'].present?
          { status: :error, code: response.response.code, error: parsed_response['error']['message'] }
        else
          rules = parsed_response['rules']
          { status: :success, code: 200, rules: rules.select { |rule| rule['tag'] == tag } }
        end
      rescue Exception => e
        { status: :error, code: 500, error: e.message }
      end

      # delete all rules from PowerTrack
      # http://support.gnip.com/apis/powertrack/api_reference.html#DeleteRules
      # Request Body Size Limit 1 MB (~5000 rules)
      def delete_all!
        retry_times = 0
        begin
          rules_list = list
          (rules_list[:rules] || []).in_groups_of(2, false).each do |group_of_rules|
            remove("rules": group_of_rules)
          end
          sleep 0.05
          rules_list = list
          if !(rules_list[:rules] || []).size.zero?
            delete_all!
          else
            { status: :success, code: 200, rules: [] }
          end
        rescue Exception => e
          retry_times += 1
          if retry_times <= 3
            retry
          else
            { status: :error, code: 500, error: e.message }
          end
        end
      end

      private

        def safe_parsed_response(parsed_response)
          ret = parsed_response.present? ? (parsed_response.is_a?(String) ? JSON.parse(parsed_response).with_indifferent_access : parsed_response) : nil
          ret
        end
    end
  end
end
