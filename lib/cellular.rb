require 'cellular/version'
require 'cellular/configuration'
require 'cellular/models/sms'

module Cellular

  class << self
    attr_accessor :config

    def configure
      yield config
    end

    def config
      @config ||= Configuration.new
    end
  end

end
