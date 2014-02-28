require "lita"

module Lita
  module Handlers
    class BitbucketWehbhook < Handler
    end

    Lita.register_handler(BitbucketWehbhook)
  end
end

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "..", "..", "locales", "*.yml"), __FILE__
)]
