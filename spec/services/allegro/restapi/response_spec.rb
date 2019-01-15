# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Allegro::Restapi::Response do
  subject { described_class.new(httparty_response: httparty_response) }

  let(:httparty_response) { instance_double(HTTParty::Response) }
  let(:httparty_body) { 'body' }

  before { allow(httparty_response).to receive(:body).and_return(httparty_body) }

  describe '#body' do
    context 'when httparty body is a serialized json' do
      let(:httparty_body) { '{"id":"c0cc859d-1c8a-436e-a2f4-3ad5c19f7c4a"}' }

      it 'returns parsed json from httparty body' do
        expect(subject.body).to eq('id' => 'c0cc859d-1c8a-436e-a2f4-3ad5c19f7c4a')
      end
    end

    context 'when httparty body is not a serialized json' do
      let(:httparty_body) { 'not json' }

      it 'returns httparty body' do
        expect(subject.body).to eq 'not json'
      end
    end
  end

  describe '#failure?' do
    let(:httparty_response) { instance_double(HTTParty::Response, success?: success) }

    context 'when httparty response is not a success' do
      let(:success) { false }

      it 'returns true' do
        expect(subject.failure?).to eq true
      end
    end

    context 'when httparty response is a success' do
      let(:success) { true }

      it 'returns false' do
        expect(subject.failure?).to eq false
      end
    end
  end

  describe '#result' do
    let(:httparty_response) { instance_double(HTTParty::Response, success?: success) }

    before do
      allow(Inpost::Restapi::FailureMessage).to(
        receive(:call).and_return(Result::Success.new(data: 'parsed failure message'))
      )
    end

    context 'when httparty response is not a success' do
      let(:success) { false }

      it 'returns failure with a body and parsed message' do
        expect(subject.result).to be_a(Result::Failure)
        expect(subject.result.data).to eq 'body'
      end
    end

    context 'when httparty response is a success' do
      let(:success) { true }

      it 'returns success with a body' do
        expect(subject.result).to be_a(Result::Success)
        expect(subject.result.data).to eq 'body'
      end
    end
  end
end
