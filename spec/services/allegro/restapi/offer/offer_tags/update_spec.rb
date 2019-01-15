# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Allegro::Restapi::Offer::OfferTags::Update do
  subject { described_class.call(auction: auction, tags: tags) }

  let(:auction) { build_stubbed(:allegro_auction, account: account, auction_id: 234_567_890) }
  let(:account) { build_stubbed(:allegro_account) }

  let(:tags) do
    [
      build_stubbed(:allegro_tag, allegro_id: '19f75c79-5961-4b59-bc86-88ac48196a64'),
      build_stubbed(:allegro_tag, allegro_id: '29f75c79-5961-4b59-bc86-88ac48196a64'),
      build_stubbed(:allegro_tag, allegro_id: '39f75c79-5961-4b59-bc86-88ac48196a64')
    ]
  end

  let(:restapi_client) { double }
  let(:allegro_response) { instance_double(Allegro::Restapi::Response, result: allegro_result) }
  let(:allegro_result) { double }

  before do
    allow(account).to receive(:restapi_client).and_return(restapi_client)
    allow(restapi_client).to receive(:post).and_return(allegro_response)
  end

  it 'calls restapi_client post with proper parameters' do
    expect(restapi_client).to(
      receive(:post).with(
        endpoint: 'sale/offers/234567890/tags',
        params: {
          'tags' => [
            { 'id' => '19f75c79-5961-4b59-bc86-88ac48196a64' },
            { 'id' => '29f75c79-5961-4b59-bc86-88ac48196a64' },
            { 'id' => '39f75c79-5961-4b59-bc86-88ac48196a64' }
          ]
        }
      )
    ).once
    subject
  end

  it 'returns allegro response result' do
    expect(subject).to eq allegro_result
  end
end
