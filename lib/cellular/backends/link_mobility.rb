require 'httparty'

module Cellular
  module Backends
    # LinkMobility backend (https://www.linkmobility.com)
    class LinkMobility < Backend
      # Documentation: https://www.linkmobility.com/developers/
      BASE_URL = 'https://wsx.sp247.net/'.freeze

      HTTP_HEADERS = {
        'Content-Type' => 'application/json; charset=utf-8',
      }.freeze

      def self.deliver(options = {})
        request_queue = {}
        recipients_batch(options).each_with_index do |recipient, index|
          options[:batch] = recipient

          request = HTTParty.post(
            sms_url,
            body: payload(options),
            basic_auth: link_mobility_config,
            headers: HTTP_HEADERS
          )

          request_queue[index] = {
            recipient: options[:batch],
            response: parse_response(request)
          }
        end

        # return first response for now
        request_queue[0][:response]
      end

      def self.parse_response(response)
        [
          response['description']
        ]
      end

      def self.sms_url
        "#{BASE_URL}sms/send"
      end

      def self.link_mobility_config
        {
          username: Cellular.config.username,
          password: Cellular.config.password
        }
      end

      def self.payload(options)
        {
          source: options[:sender],
          destination: options[:batch],
          userData: options[:message],
          platformId: 'COMMON_API',
          platformPartnerId: Cellular.config.partner_id,
        }.to_json
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
