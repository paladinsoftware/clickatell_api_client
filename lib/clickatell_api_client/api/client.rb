module ClickatellApiClient
  module API
    class ClickatellAPIError < StandardError; end
    class TopUpAccountError < ClickatellAPIError; end
    class MissingFromNumberError < ClickatellAPIError; end
    class InvalidAPIResponseError < ClickatellAPIError; end

    class Client
      NO_ERROR = 200
      ERROR_MISSING_FROM_NUMBER = 106
      ERROR_TOP_UP_ACCOUNT = 301

      PROVIDER_URL = 'https://platform.clickatell.com'.freeze
      MESSAGES_ENDPOINT = '/messages'.freeze

      attr_reader :api_key

      def initialize(api_key)
        @api_key = api_key
      end

      def send_message(params)
        request(
          http_method: :post,
          endpoint: MESSAGES_ENDPOINT,
          params: params
        )
      end

      private

      def connection
        @_connection ||= Faraday.new(url: PROVIDER_URL) do |client|
          client.request :url_encoded
          client.adapter Faraday.default_adapter
          client.headers['Authorization'] = api_key
        end
      end

      def request(http_method:, endpoint:, params:)
        response = connection.public_send(http_method, endpoint, **params)
        error_code = JSON.parse(response.body)['errorCode']

        return response if successful_response?(error_code)

        error_class = case error_code
                      when ERROR_TOP_UP_ACCOUNT
                        TopUpAccountError
                      when ERROR_MISSING_FROM_NUMBER
                        MissingFromNumberError
                      else
                        InvalidAPIResponseError
                      end

        raise Object.const_get("::ClickatellApiClient::API::#{error_class}"), "Code: #{error_code}, response: #{response.body}"
      end

      def successful_response?(code)
        code.to_i == NO_ERROR || code.nil?
      end
    end
  end
end
