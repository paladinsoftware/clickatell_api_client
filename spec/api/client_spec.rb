require 'spec_helper'

RSpec.describe ClickatellApiClient::API::Client do
  let(:api_key) { '1313213' }
  let(:service_instance) { described_class.new(api_key) }
  let(:params) { {} }
  let(:connection_double) { instance_double(Faraday::Connection, post: response_body_double) }

  describe '#send_message' do
    let(:response_body_double) { double(:response_body_double, body: { errorCode: 200 }.to_json) }

    subject { service_instance.send_message(params) }

    before do
      allow(Faraday).to receive(:new).with(url: described_class::PROVIDER_URL).and_return(connection_double)
    end

    context 'successful request' do
      it 'receives a POST request with valid params' do
        expect(connection_double).to receive(:post).with('/messages', params)
        expect(subject).to eq(response_body_double)
      end
    end

    context '106 status code' do
      let(:response_body_double) { double(:response_body_double, body: { errorCode: 106 }.to_json) }

      it 'raises a MissingFromNumberError exception' do
        expect { subject }.to raise_error(ClickatellApiClient::API::MissingFromNumberError)
      end
    end

    context '301 status code' do
      let(:response_body_double) { double(:response_body_double, body: { errorCode: 301 }.to_json) }

      it 'raises a TopUpAccountError exception' do
        expect { subject }.to raise_error(ClickatellApiClient::API::TopUpAccountError)
      end
    end

    context 'other status code' do
      let(:response_body_double) { double(:response_body_double, body: { errorCode: 455 }.to_json) }

      it 'raises an InvalidAPIResponseError exception' do
        expect { subject }.to raise_error(ClickatellApiClient::API::InvalidAPIResponseError)
      end
    end
  end
end
