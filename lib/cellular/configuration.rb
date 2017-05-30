require 'logger'

module Cellular
  # Configuration for Cellular
  class Configuration
    attr_accessor :username, :password, :delivery_url, :backend
    attr_accessor :country_code, :price, :sender, :partner_id
    attr_accessor :logger

    def logger
      @logger ||= Logger.new($stdout)
    end
  end
end
