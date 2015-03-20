begin
  require "sidekiq"
rescue LoadError
end

module Cellular
  module Jobs
    require 'cellular/jobs/async_job'
  end
end
