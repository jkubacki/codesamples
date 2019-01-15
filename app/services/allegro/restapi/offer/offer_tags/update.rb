# frozen_string_literal: true

class Allegro::Restapi::Offer::OfferTags::Update < ApplicationService
  attr_private_initialize %i[auction! tags!]

  def call
    response = client.post(
      endpoint: "sale/offers/#{auction.auction_id}/tags",
      params: {
        'tags' => tags_params
      }
    )
    response.result
  end

  private

  def client
    auction.account.restapi_client
  end

  def tags_params
    tags.map { |tag| { 'id' => tag.allegro_id } }
  end
end
