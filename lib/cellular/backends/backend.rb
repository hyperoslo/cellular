module Cellular
  module Backends
    # Base class for a Cellular backend
    class Backend
      def self.deliver(_options = {})
        raise NotImplementedError
      end

      def self.receive(_data)
        raise NotImplementedError
      end
    end
  end
end
