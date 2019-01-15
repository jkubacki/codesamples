# frozen_string_literal: true

class Allegro::Restapi::Offer::Price::Update < ApplicationService
  attr_private_initialize %i[auction! price!]

  CURRENCY = 'PLN'

  def call
    response = client.put(
      endpoint: endpoint,
      params: params
    )
    response.result
  end

  private

  def client
    auction.account.restapi_client
  end

  def endpoint
    "offers/#{auction.auction_id}/change-price-commands/#{request_id}"
  end

  def request_id
    @request_id ||= SecureRandom.uuid
  end

  def params
    {
      id: request_id,
      input: {
        'buyNowPrice' => {
          amount: price.to_s.tr(',', '.'),
          currency: CURRENCY
        }
      }
    }
  end
end
