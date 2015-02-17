module Cellular

  # An API compatible logger when not in a rails environment
  # logs to stdout
  class Logger
    def info(message)
      $stdout.puts message
    end
  end

end

