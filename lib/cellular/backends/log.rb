module Cellular
  module Backends
    # Writes SMS messages to configured logger
    class Log < Backend
      def self.deliver(options = {})
        Cellular.config.logger.info options[:message]
      end
    end
  end
end
