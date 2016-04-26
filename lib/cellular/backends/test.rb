module Cellular
  module Backends
    # Test backend appends deliveries to Cellular.deliveries
    class Test < Backend
      def self.deliver(options = {})
        Cellular.deliveries << options[:message]
      end
    end
  end
end
