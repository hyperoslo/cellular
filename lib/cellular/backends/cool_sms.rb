require 'httparty'

module Cellular
  module Backends
    class CoolSMS

      # Documentation: http://www.coolsms.com/support/dokumentation/http-gateway.sms
      GATEWAY_URL = 'https://sms.coolsmsc.dk/'

      def self.deliver(options = {})
        query = {
          username: Cellular.config.username,
          password: Cellular.config.password,
          from: options[:sender],
          to: options[:recipient],
          message: options[:message],
          charset: 'utf-8',
          resulttype: 'xml',
          lang: 'en'
        }

        result = HTTParty.get(GATEWAY_URL, query: query)
        response = result.parsed_response['smsc']

        [
          response['status'],
          response['result'] || response['message']['result']
        ]
      end

    end
  end
end
