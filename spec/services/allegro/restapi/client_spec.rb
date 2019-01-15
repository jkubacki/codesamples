# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Allegro::Restapi::Client do
  let(:client) { described_class.new(account: account) }
  let(:account) do
    build_stubbed(:allegro_account, token: 'access_token')
  end
  let(:httparty_response) { instance_double(HTTParty::Response) }

  before do
    allow(account).to receive(:restapi_key).and_return('restapi_key')
    allow(account).to receive(:restapi_site).and_return('https://api.allegro.pl')
    allow(Allegro::Restapi::Tokens::HandleInvalidTokenResponse).to receive(:call)
  end

  shared_examples 'sends request' do |method|
    it 'sends get request with proper parameters' do
      expect(HTTParty).to(
        receive(method).with(
          'https://api.allegro.pl/endpoint',
          body: { key: 'param' }.to_json,
          headers: {
            'Authorization' => 'Bearer access_token',
            'Api-key' => 'restapi_key',
            'Accept' => 'application/vnd.allegro.public.v1+json;charset=UTF-8',
            'Content-Type' => 'application/vnd.allegro.public.v1+json',
            'accept-language' => 'PL'
          }
        )
      ).once
      subject
    end
  end

  shared_examples 'refreshes restapi token' do
    it 'refreshes restapi token' do
      expect(account).to receive(:refresh_restapi_token).once.and_return(nil)
      subject
    end

    it 'returns allegro response' do
      expect(subject).to be_a Allegro::Restapi::Response
      expect(subject.httparty_response).to eq httparty_response
    end
  end

  shared_examples 'handles invalid token response' do
    it 'handles invalid token response' do
      expect(Allegro::Restapi::Tokens::HandleInvalidTokenResponse).to(
        receive(:call).with(response: httparty_response, account: account)
      ).once
      subject
    end
  end

  describe '#get' do
    subject { client.get(endpoint: 'endpoint', params: { key: 'param' }) }

    before { allow(HTTParty).to receive(:get).and_return(httparty_response) }

    it_behaves_like 'sends request', :get
    it_behaves_like 'refreshes restapi token'
    it_behaves_like 'handles invalid token response'
  end

  describe '#post' do
    subject { client.post(endpoint: 'endpoint', params: { key: 'param' }) }

    before { allow(HTTParty).to receive(:post).and_return(httparty_response) }

    it_behaves_like 'sends request', :post
    it_behaves_like 'refreshes restapi token'
    it_behaves_like 'handles invalid token response'
  end

  describe '#put' do
    subject { client.put(endpoint: 'endpoint', params: { key: 'param' }) }

    before { allow(HTTParty).to receive(:put).and_return(httparty_response) }

    it_behaves_like 'sends request', :put
    it_behaves_like 'refreshes restapi token'
    it_behaves_like 'handles invalid token response'
  end

  describe '#delete' do
    subject { client.delete(endpoint: 'endpoint', params: { key: 'param' }) }

    before { allow(HTTParty).to receive(:delete).and_return(httparty_response) }

    it_behaves_like 'sends request', :delete
    it_behaves_like 'refreshes restapi token'
    it_behaves_like 'handles invalid token response'
  end
end
