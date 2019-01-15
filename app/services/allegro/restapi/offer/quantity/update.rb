# frozen_string_literal: true

class Allegro::Restapi::Offer::Quantity::Update < ApplicationService
  attr_private_initialize %i[auctions! allegro_account! quantity!]

  CHANGE_TYPE = 'FIXED'
  CRITERIA_TYPE = 'CONTAINS_OFFERS'

  def call
    response = client.put(
      endpoint: endpoint,
      params: params
    )
    response.result
  end

  private

  def client
    allegro_account.restapi_client
  end

  def endpoint
    "sale/offer-quantity-change-commands/#{request_id}"
  end

  def request_id
    @request_id ||= SecureRandom.uuid
  end

  def params
    {
      modification: {
        'changeType' => CHANGE_TYPE,
        value: quantity
      },
      'offerCriteria' => [
        {
          offers: auction_ids,
          type: CRITERIA_TYPE
        }
      ]
    }
  end

  def auction_ids
    auctions.each_with_object([]) do |auction, array|
      array << { id: auction.auction_id.to_s }
    end
  end
end
