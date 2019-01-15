# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Allegro::Restapi::Sale::Offer::Get do
  subject { described_class.call(auction: auction) }

  let(:auction) { build_stubbed(:allegro_auction, account: account, auction_id: 123) }
  let(:account) { build_stubbed(:allegro_account) }

  let(:restapi_client) { double }
  let(:allegro_response) { instance_double(Allegro::Restapi::Response, result: allegro_result) }
  let(:allegro_result) { double }

  before do
    allow(account).to receive(:restapi_client).and_return(restapi_client)
    allow(restapi_client).to receive(:get).and_return(allegro_response)
  end

  it 'calls restapi_client get with proper endpoint' do
    expect(restapi_client).to(
      receive(:get).with(
        endpoint: 'sale/offers/123'
      )
    ).once
    subject
  end

  it 'returns allegro response result' do
    expect(subject).to eq allegro_result
  end
end
