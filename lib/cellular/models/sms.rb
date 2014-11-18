module Cellular
  class SMS

    attr_accessor :recipient, :sender, :message, :price, :country_code

    def initialize(options = {})
      @backend = Cellular.config.backend

      @recipient = options[:recipient]
      @sender = options[:sender] || Cellular.config.sender
      @message = options[:message]
      @price = options[:price] || Cellular.config.price
      @country_code = options[:country_code] || Cellular.config.country_code

      @delivered = false
    end

    def deliver
      @delivery_status, @delivery_message = @backend.deliver(
        recipient: @recipient,
        sender: @sender,
        price: @price,
        country_code: @country_code,
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
    
    def country
      warn "[DEPRECATION] 'country' is deprecated; use 'country_code' instead"
      @country_code
    end

    def country=(country)
      warn "[DEPRECATION] 'country' is deprecated; use 'country_code' instead"
      @country_code = country
    end

  end
end
