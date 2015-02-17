module Cellular
  module Backends
    class Backend
      def self.deliver(options = {})
        raise NotImplementedError
      end

      def self.receive(data)
        raise NotImplementedError
      end
    end
  end
end
