# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Allegro::Restapi::Offer::Quantity::Update do
  subject { described_class.call(auctions: [auction], allegro_account: account, quantity: 10) }

  let(:auction) { build_stubbed(:allegro_auction, account: account, auction_id: 123) }
  let(:account) { build_stubbed(:allegro_account) }

  let(:restapi_client) { double }
  let(:allegro_response) { instance_double(Allegro::Restapi::Response, result: allegro_result) }
  let(:allegro_result) { double }

  before do
    allow(account).to receive(:restapi_client).and_return(restapi_client)
    allow(restapi_client).to receive(:put).and_return(allegro_response)
    allow(SecureRandom).to receive(:uuid).and_return('fce18dd2-99fa-411d-abae-d49b66b0b804')
  end

  it 'calls restapi_client put with proper parameters and parsed quantity' do
    expect(restapi_client).to(
      receive(:put).with(
        endpoint: 'sale/offer-quantity-change-commands/fce18dd2-99fa-411d-abae-d49b66b0b804',
        params: {
          modification: {
            'changeType' => 'FIXED',
            value: 10
          },
          'offerCriteria' => [
            {
              offers: [
                {
                  id: '123'
                }
              ],
              type: 'CONTAINS_OFFERS'
            }
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
