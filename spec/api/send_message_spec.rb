require 'spec_helper'

RSpec.describe ClickatellApiClient::API::SendMessage do
  let(:message) { 'message' }
  let(:apiMessageId) { 'apiMessageId' }
  let(:service_instance) { described_class.new(telephone: telephone, message: message) }
  let(:request_double) { double(:request_double, post: true) }
  let(:client_double) { instance_double(ClickatellApiClient::API::Client) }
  let(:us_number_validator_double) { instance_double(ClickatellApiClient::TelephoneNumber::UsNumberValidator, call: us_phone_number) }
  let(:response_body) do
    {
      messages: [
        {
          apiMessageId: apiMessageId,
          to: telephone,
          accepted: 'true'
        }
      ]
    }
  end
  let(:response_double) { double(body: response_body.to_json) }

  before do
    ClickatellApiClient.configure do |config|
      config.api_key = 'api_key'
      config.us_api_key = 'us_api_key'
      config.phone_number = 'phone_number'
    end
  end

  after(:all) do
    ClickatellApiClient.configuration = nil
  end

  describe '#call' do
    subject { service_instance.call }

    before do
      allow(ClickatellApiClient::TelephoneNumber::UsNumberValidator).to receive(:new).with(telephone).and_return(us_number_validator_double)
    end

    context 'successful request' do
      context 'US phone number' do
        let(:telephone) { '+11234567899' }
        let(:us_phone_number) { true }
        let(:params) do
          {
            content: message,
            to: telephone,
            from: ClickatellApiClient.configuration.phone_number
          }
        end

        before do
          allow(ClickatellApiClient::API::Client).to receive(:new).with(ClickatellApiClient.configuration.us_api_key).and_return(client_double)
          allow(client_double).to receive(:send_message).with(params).and_return(response_double)
        end

        it 'sends a SMS message' do
          expect(us_number_validator_double).to receive(:call)
          expect(subject).to eq({
            message_id: apiMessageId,
            to: telephone,
            send: 'true'
          })
        end
      end

      context 'non US phone number' do
        let(:telephone) { '+48600111222' }
        let(:us_phone_number) { false }
        let(:params) do
          {
            content: message,
            to: telephone
          }
        end

        before do
          allow(ClickatellApiClient::API::Client).to receive(:new).with(ClickatellApiClient.configuration.api_key).and_return(client_double)
          allow(client_double).to receive(:send_message).with(params).and_return(response_double)
        end

        it 'sends a SMS message' do
          expect(us_number_validator_double).to receive(:call)
          expect(subject).to eq({
            message_id: apiMessageId,
            to: telephone,
            send: 'true'
          })
        end
      end
    end

    shared_examples 'client error' do |error_name|
      let(:telephone) { '+48600111222' }
      let(:us_phone_number) { false }
      let(:params) do
        {
          content: message,
          to: telephone
        }
      end

      before do
        allow(ClickatellApiClient::API::Client).to receive(:new).with(ClickatellApiClient.configuration.api_key).and_return(client_double)
        allow(client_double).to receive(:send_message).with(params).and_raise(Object.const_get("ClickatellApiClient::API::#{error_name}"))
      end

      it 'raises a ClickatellApiError error' do
        expect { subject }.to raise_error(ClickatellApiClient::API::ClickatellAPIError)
      end
    end

    context 'Client::TopUpAccountError' do
      it_behaves_like 'client error', 'TopUpAccountError'
    end

    context 'Client::MissingFromNumberError' do
      it_behaves_like 'client error', 'MissingFromNumberError'
    end

    context 'Client::InvalidAPIResponseError' do
      it_behaves_like 'client error', 'InvalidAPIResponseError'
    end
  end
end
