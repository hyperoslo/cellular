require 'httparty'

module Cellular
  module Backends
    class Twilio < Backend
      # Documentation: https://www.twilio.com/docs/api/rest
      API_VERSION = '2010-04-01'
      BASE_URL = 'https://api.twilio.com/'
      API_URL = BASE_URL + API_VERSION

      HTTP_HEADERS = {
        'Accept' => 'application/json',
        'Accept-Charset' => 'utf-8',
        'User-Agent' => "cellular/#{Cellular::VERSION}" \
        " (#{RUBY_ENGINE}/#{RUBY_PLATFORM}" \
        " #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL})"
      }

      def self.deliver(options = {})
        request_queue = {}

        recipients_batch(options).each_with_index do |recipient, index|
          result = HTTParty.post(
            "#{API_URL}/Accounts/#{twilio_config[:username]}/Messages",
            body: payload(options),
            basic_auth: twilio_config,
            headers: HTTP_HEADERS
          )

          request_queue[index] = {
            recipient: options[:batch],
            response: result.parsed_response
          }
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
          From: options[:sender],
          To: options[:batch],
          Body: options[:message],
          MaxPrice: options[:price] || 0.50
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
