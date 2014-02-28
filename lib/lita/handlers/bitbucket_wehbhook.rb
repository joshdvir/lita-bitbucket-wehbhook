require "lita"

module Lita
  module Handlers
    class BitbucketWehbhook < Handler
      http.post "/bitbucket-webhook", :receive

      def receive(request, response)
        json_data = parse_josn(request.params['payload']) or return
        send_message(json_data)
      end

      private

      def parse_josn(json)
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

      def send_message(json)
        message = format_message(json)
        response.reply(message)
      end

    end

    Lita.register_handler(BitbucketWehbhook)
  end
end

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "..", "..", "locales", "*.yml"), __FILE__
)]
