require 'json'
require 'faraday'
require 'clickatell_api_client/version'
require 'clickatell_api_client/telephone_number/us_number_validator'
require 'clickatell_api_client/api/client'
require 'clickatell_api_client/api/send_message'

module ClickatellApiClient
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :phone_number, :us_api_key, :api_key
  end
end
