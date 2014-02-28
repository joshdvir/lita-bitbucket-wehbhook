require "lita"

module Lita
  module Handlers
    class BitbucketWehbhook < Handler

      def self.default_config(config)
        config.rooms = :all
      end

      http.post "/bitbucket-webhook", :receive

      def receive(request, response)
        json_data = parse_json(request.params['payload']) or return
        message = format_message(json_data)
        target = Source.new(nil, Lita.config.handlers.bitbucket_wehbhook.rooms)
        robot.send_message(target, message)
      end

      private

      def parse_json(json)
        MultiJson.load(json)
      rescue MultiJson::LoadError => e
        Lita.logger.error("Could not parse JSON from Bitbucket: #{e.message}")
        return
      end

      def format_message(json)
        branches = Hash.new

        json['commits'].each do |c|
          branches[c['branch']] = "<b>On branch \"#{c['branch']}</b>\" \n" if branches[c['branch']].nil?
          branches[c['branch']] << "- #{c['message']} (#{json['canon_url'] + json['repository']['absolute_url'] + 'commits/' + c['node']})}\n"
        end

        "[Bitbucket] <b>#{json['commits'].first['author']}<b> committed to #{branches.size} branches at #{json['canon_url'] + json['repository']['absolute_url']}\n
        #{branches.each { |b| b[1] }}"
      rescue
        Lita.logger.warn "Error formatting message for #{repo} repo. JSON: #{json}"
        return
      end
    end

    Lita.register_handler(BitbucketWehbhook)
  end
end

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "..", "..", "locales", "*.yml"), __FILE__
)]
