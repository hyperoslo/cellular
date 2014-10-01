require 'cellular/version'
require 'cellular/configuration'
require 'cellular/models/sms'
require 'cellular/backends'
require 'cellular/jobs'

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
