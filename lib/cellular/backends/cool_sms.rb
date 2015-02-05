require 'httparty'

module Cellular
  module Backends
    class CoolSMS

      # Documentation: http://www.coolsms.com/support/dokumentation/http-gateway.sms
      GATEWAY_URL = 'https://sms.coolsmsc.dk/'

      def self.deliver(options = {})
        result = HTTParty.get(GATEWAY_URL, query: payload(options) )
        parse_response(result.parsed_response['smsc'])
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

      def self.payload(options)
        {
          from: options[:sender],
          to: options[:recipient],
          message: options[:message],
          charset: 'utf-8',
          resulttype: 'xml',
          lang: 'en'
        }.merge!(coolsms_config)
      end

    end
  end
end
