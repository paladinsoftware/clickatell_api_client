module ClickatellApiClient
  module API
    class SendMessage
      attr_reader :telephone, :message

      def initialize(telephone:, message:)
        @telephone = telephone
        @message = message
      end

      def call
        response = client.send_message(sms_attributes)
        response_body = JSON.parse(response.body)

        response_data(response_body)
      end

      private

      def client
        @_client = Client.new(api_key)
      end

      def api_key
        if us_phone_number?
          ClickatellApiClient.configuration.us_api_key
        else
          ClickatellApiClient.configuration.api_key
        end
      end

      def us_phone_number?
        @_us_phone_number ||= TelephoneNumber::UsNumberValidator.new(telephone).call
      end

      def sms_attributes
        if us_phone_number?
          default_attributes.merge(from: ClickatellApiClient.configuration.phone_number)
        else
          default_attributes
        end
      end

      def default_attributes
        {
          content: message,
          to: telephone
        }
      end

      def response_data(response_body)
        {
          message_id: response_body['messages'].first['apiMessageId'],
          to: response_body['messages'].first['to'],
          send: response_body['messages'].first['accepted']
        }
      end
    end
  end
end
