module Cellular
  module Backends
    class Test < Backend
      def self.deliver(options = {})
        Cellular.deliveries << options[:message]
      end
    end
  end
end
