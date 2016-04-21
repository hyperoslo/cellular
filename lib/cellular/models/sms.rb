require 'active_support/time'

module Cellular
  class SMS

    attr_accessor :recipient, :sender, :message, :price, :country_code
    attr_accessor :recipients, :delivery_status, :delivery_message
    def initialize(options = {})
      @backend = Cellular.config.backend

      @recipients = options[:recipients]
      @recipient = options[:recipient]
      @sender = options[:sender] || Cellular.config.sender
      @message = options[:message]
      @price = options[:price] || Cellular.config.price
      @country_code = options[:country_code] || Cellular.config.country_code

      @delivered = false
    end

    def deliver
      @delivery_status, @delivery_message = @backend.deliver options
      @delivered = true
    end

    def deliver_async(delivery_options = {})
      Cellular::Jobs::AsyncMessenger.set(delivery_options).perform_later(options)
    end
    alias_method :deliver_later, :deliver_async

    def save(options = {})
      raise NotImplementedError
    end

    def receive(options = {})
      raise NotImplementedError
    end

    def delivered?
      @delivered
    end

    private

    def options
      {
        recipients: @recipients,
        recipient: @recipient,
        sender: @sender,
        message: @message,
        price: @price,
        country_code: @country_code
      }
    end

  end
end
