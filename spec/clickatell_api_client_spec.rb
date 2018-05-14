require 'spec_helper'

RSpec.describe ClickatellApiClient do
  describe 'version' do
    it 'has a version number' do
      expect(ClickatellApiClient::VERSION).not_to be nil
    end
  end

  describe '.configure' do
    let(:api_key) { 'api_key' }
    let(:us_api_key) { 'us_api_key' }
    let(:phone_number) { 'phone_number' }

    it 'allows to configure settings' do
      expect(described_class.configuration).to eq(nil)

      described_class.configure do |config|
        config.api_key = api_key
        config.us_api_key = us_api_key
        config.phone_number = phone_number
      end

      expect(described_class.configuration).to be_instance_of(ClickatellApiClient::Configuration)
      expect(described_class.configuration.api_key).to eq(api_key)
      expect(described_class.configuration.us_api_key).to eq(us_api_key)
      expect(described_class.configuration.phone_number).to eq(phone_number)
    end
  end
end
