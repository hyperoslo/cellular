module Cellular
  module Backends
    class Log < Backend
      def self.deliver(options = {})
        Cellular.config.logger.info options[:message]
      end
    end
  end
end
