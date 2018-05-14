module ClickatellApiClient
  module TelephoneNumber
    class UsNumberValidator
      US_PHONE_NUMBER_REGEXP = /^\+1\d{10}$/

      attr_reader :telephone

      def initialize(telephone)
        @telephone = telephone
      end

      def call
        !!US_PHONE_NUMBER_REGEXP.match(telephone)
      end
    end
  end
end
