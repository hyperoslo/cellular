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
        # http://controlpanel.sendega.no/Content/Sendega%20-%20API%20documentation%20v2.3.pdf

        savon_options[:wsdl] = GATEWAY_URL
        request_queue = {}
        client = Savon.client savon_options

        recipients_batch(options).each_with_index do |_batch, _index|
          result = client.call(:send, message: payload(options, _batch))

          request_queue[_index] = {
            batch: _batch,
            result: result,
            body:result.body[:send_response][:send_result],
            response: map_response(result.body[:send_response][:send_result])
          }
        end

        # for now just resturn first response
        request_queue[0][:response]
      end

      def self.receive(data)
        raise NotImplementedError
      end

      def self.savon_config
        {
           username: Cellular.config.username,
           password: Cellular.config.password,
           dlrUrl: Cellular.config.delivery_url
        }
      end

      def self.payload(options, recipients)
       {
          sender: options[:sender],
          destination: recipients,
          pricegroup: options[:price] || 0, # default price to 0
          contentTypeID: 1,
          contentHeader: '',
          content: options[:message],
          ageLimit: 0,
          extID: '',
          sendDate: '',
          refID: '',
          priority: 0,
          gwID: 0,
          pid: 0,
          dcs: 0
        }.merge!(savon_config)
      end

      def self.map_response(_body)
        msg = _body[:success] ?  success_message : _body[:error_message]
        [ _body[:error_number].to_i, msg ]
      end

      def self.success_message
        'Message is received and is being processed.'
      end

      def self.recipients_batch(options)
        if options[:receipients].blank?
          [options[:recipient]]
        else
          options[:receipients].each_slice(100).to_a.map{|x| x.join(',') }
        end
      end

    end
  end
end
