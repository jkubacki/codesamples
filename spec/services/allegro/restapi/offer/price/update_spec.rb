# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Allegro::Restapi::Offer::Price::Update do
  subject { described_class.call(auction: auction, price: '9,99') }

  let(:auction) { build_stubbed(:allegro_auction, account: account, auction_id: 123) }
  let(:account) { build_stubbed(:allegro_account) }

  let(:restapi_client) { double }
  let(:allegro_response) { instance_double(Allegro::Restapi::Response, result: allegro_result) }
  let(:allegro_result) { double }

  before do
    allow(account).to receive(:restapi_client).and_return(restapi_client)
    allow(restapi_client).to receive(:put).and_return(allegro_response)
    allow(SecureRandom).to receive(:uuid).and_return('58a498ca-15d1-43a2-97c0-4b0e3122815e')
  end

  it 'calls restapi_client post with proper parameters and parsed price' do
    expect(restapi_client).to(
      receive(:put).with(
        endpoint: 'offers/123/change-price-commands/58a498ca-15d1-43a2-97c0-4b0e3122815e',
        params: {
          id: '58a498ca-15d1-43a2-97c0-4b0e3122815e',
          input: { 'buyNowPrice' => { amount: '9.99', currency: described_class::CURRENCY } }
        }
      )
    ).once
    subject
  end

  it 'returns allegro response result' do
    expect(subject).to eq allegro_result
  end
end
