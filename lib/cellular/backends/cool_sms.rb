require 'httparty'

module Cellular
  module Backends
    class CoolSMS

      # Documentation: http://www.coolsms.com/support/dokumentation/http-gateway.sms
      GATEWAY_URL = 'https://sms.coolsmsc.dk/'

      def self.deliver(options = {})
        request_que = {}

        recipients_batch(options).each_with_index do |recipient, _index|
          result = HTTParty.get(GATEWAY_URL, query: payload(options, recipient) )
          request_que[_index] = {
            recipient: recipient,
            response: parse_response(result.parsed_response['smsc'])
          }
        end

        # return first response for now
        request_que[0][:response]
      end

      def self.parse_response(response)
        [
          response['status'],
          response['result'] || response['message']['result']
        ]
      end

      def self.coolsms_config
        {
          username: Cellular.config.username,
          password: Cellular.config.password
        }
      end

      def self.payload(options, recipient)
        {
          from: options[:sender],
          to: options[:recipient],
          message: options[:message],
          charset: 'utf-8',
          resulttype: 'xml',
          lang: 'en'
        }.merge!(coolsms_config)
      end

      def self.recipients_batch(options)
        if options[:receipients].blank?
          [options[:recipient]]
        else
          options[:receipients]
        end
      end

    end
  end
end
