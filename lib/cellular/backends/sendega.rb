require 'savon'

module Cellular
  module Backends
    class Sendega

      GATEWAY_URL = 'https://smsc.sendega.com/Content.asmx?WSDL'

      def self.deliver(options = {}, savon_options = {})
        # Send an SMS and return its initial delivery status code.
        #
        # Delivery status codes:
        #    0 -- Message is received and is being processed.
        # 1001 -- Not validated
        # 1003 -- Wrong format: pid/dcs
        # 1004 -- Erroneous typeid
        # 1020 -- Fromalpha too long
        # 1021 -- Fromnumber too long
        # 1022 -- Erroneous recipient, integer overflow
        # 1023 -- No message content submitted
        # 1024 -- Premium sms must have abbreviated number as sender
        # 1025 -- The message sender is not allowed
        # 1026 -- Balance to low
        # 1027 -- Message too long
        # 1028 -- Alphanumeric sender is not valid
        # 1099 -- Internal error
        # 9001 -- Username and password does not match
        # 9002 -- Account is closed
        # 9004 -- Http not enabled
        # 9005 -- Smpp not enabled
        # 9006 -- Ip not allowed
        # 9007 -- Demo account empty
        #
        # See Gate API Documentation:
        # http://www.sendega.no/downloads/Sendega%20API%20documentation%20v2.0.pdf

        savon_options[:wsdl] = GATEWAY_URL

        client = Savon.client savon_options

        result = client.call(:send, message: {
            username: Cellular.config.username,
            password: Cellular.config.password,
            sender: options[:sender],
            destination: options[:recipient],
            pricegroup: options[:price] || 0, # default price to 0
            contentTypeID: 1,
            contentHeader: '',
            content: options[:message],
            dlrUrl: Cellular.config.delivery_url,
            ageLimit: 0,
            extID: '',
            sendDate: '',
            refID: '',
            priority: 0,
            gwID: 0,
            pid: 0,
            dcs: 0
          }
        )

        if result.success?
          [ result.body[:error_number], 'Message is received and is being processed.' ]
        else
          [ result.body[:error_number], result.body[:error_message] ]
        end
      end

      def self.receive(data)
        raise NotImplementedError
      end

    end
  end
end
