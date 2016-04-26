module Cellular
  # API compatible logger when not in a Rails environment
  # Logs to stdout
  class Logger
    def info(message)
      $stdout.puts message
    end
  end
end
