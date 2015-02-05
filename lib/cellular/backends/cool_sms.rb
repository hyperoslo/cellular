require 'httparty'

module Cellular
  module Backends
    class CoolSMS

      # Documentation: http://www.coolsms.com/support/dokumentation/http-gateway.sms
      GATEWAY_URL = 'https://sms.coolsmsc.dk/'

      def self.deliver(options = {})
        request_queue = {}

        receipients_batch(options).each_with_index do |recipient, index|
          options[:batch] = recipient
          result = HTTParty.get(GATEWAY_URL, query: defaults_with(options) )
          request_queue[index] = {
            recipient: recipient,
            response: parse_response(result.parsed_response['smsc'])
          }
        end

        # return first response for now
        request_queue[0][:response]
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

      def self.defaults_with(options)
        {
          from: options[:sender],
          to: options[:batch],
          message: options[:message],
          charset: 'utf-8',
          resulttype: 'xml',
          lang: 'en'
        }.merge!(coolsms_config)
      end

      def self.receipients_batch(options)
        if options[:receipients].blank?
          [options[:recipient]]
        else
          options[:receipients]
        end
      end

    end
  end
end
