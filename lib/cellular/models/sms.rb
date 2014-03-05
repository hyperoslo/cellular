module Cellular
  class SMS

    attr_accessor :recipient, :sender, :message, :price, :country

    def initialize(options = {})
      @backend = Cellular.config.backend

      @recipient = options[:recipient]
      @sender = options[:sender] || Cellular.config.sender
      @message = options[:message]
      @price = options[:price] || Cellular.config.price
      @country = options[:country] || Cellular.config.country_code

      @delivered = false
    end

    def deliver
      @delivery_status, @delivery_message = @backend.deliver(
        recipient: @recipient,
        sender: @sender,
        price: @price,
        country: @country,
        message: @message
      )

      @delivered = true
    end

    def save(options = {})
      raise NotImplementedError
    end

    def receive(options = {})
      raise NotImplementedError
    end

    def delivered?
      @delivered
    end

  end
end
