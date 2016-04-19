require 'httparty'

module Cellular
  module Backends
    class Twilio < Backend

      # Documentation: https://www.twilio.com/docs/api/rest
      GATEWAY_URL = 'https://api.twilio.com/2010-04-01'

      def self.deliver(options = {})
        request_queue = {}

        recipients_batch(options).each_with_index do |recipient, index|
          options[:batch] = recipient
          result = HTTParty.post(
            "#{GATEWAY_URL}/Accounts/#{twilio_config[:username]}/Messages",
            body: payload(options),
            basic_auth: twilio_config
            )
        end

        # return first response for now
        request_queue[0][:response]
      end


      def self.twilio_config
        {
          username: Cellular.config.username,
          password: Cellular.config.password
        }
      end

      def self.payload(options)
        {
          from: options[:sender],
          to: options[:batch],
          body: options[:message]
        }
      end

      def self.recipients_batch(options)
        if options[:recipients].blank?
          [options[:recipient]]
        else
          options[:recipients]
        end
      end

    end
  end
end
