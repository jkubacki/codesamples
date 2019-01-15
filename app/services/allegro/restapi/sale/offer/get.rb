# frozen_string_literal: true

class Allegro::Restapi::Sale::Offer::Get < ApplicationService
  attr_private_initialize %i[auction!]

  def call
    response = client.get(
      endpoint: endpoint
    )
    response.result
  end

  private

  def client
    auction.account.restapi_client
  end

  def endpoint
    "sale/offers/#{auction.auction_id}"
  end
end
