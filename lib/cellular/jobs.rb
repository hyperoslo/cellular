begin
  require 'sidekiq'
rescue LoadError
end

module Cellular
  # Encapsulates all background job implementations
  module Jobs
    require 'cellular/jobs/async_messenger'
  end
end
