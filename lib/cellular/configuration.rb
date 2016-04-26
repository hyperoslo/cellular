module Cellular
  # Configuration for Cellular
  class Configuration
    attr_accessor :username, :password, :delivery_url, :backend
    attr_accessor :country_code, :price, :sender
    attr_accessor :logger

    def logger
      @logger ||= Object.const_defined?(:Rails) ? Rails.logger : Logger.new
    end
  end
end
