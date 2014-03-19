module Cellular
  module Backends
    class Log
      def self.deliver(options = {}, savon_options = {})
        STDOUT.puts options[:message]
      end

      def self.receive(data)
        raise NotImplementedError
      end
    end
  end
end