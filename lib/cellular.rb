require 'cellular/version'
require 'cellular/configuration'
require 'cellular/models/sms'
require 'cellular/backends'

begin
  require "sidekiq"
rescue LoadError
end

module Cellular
  @deliveries = []

  class << self
    attr_accessor :deliveries
    attr_accessor :config

    def configure
      yield config
    end

    def config
      @config ||= Configuration.new
    end
  end

end
