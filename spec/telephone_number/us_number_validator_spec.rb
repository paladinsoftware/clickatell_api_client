require 'spec_helper'

RSpec.describe ClickatellApiClient::TelephoneNumber::UsNumberValidator do
  let(:service_instance) { described_class.new(telephone) }

  describe '#call' do
    subject { service_instance.call }

    context 'US phone number' do
      let(:telephone) { '+11234567899' }

      it { is_expected.to be_truthy }
    end

    context 'not US phone number' do
      let(:telephone) { '+48600111222' }

      it { is_expected.to be_falsy }
    end
  end
end
