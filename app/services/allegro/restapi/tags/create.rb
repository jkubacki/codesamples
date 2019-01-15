# frozen_string_literal: true

class Allegro::Restapi::Tags::Create < ApplicationServiceInTransaction
  attr_private_initialize %i[account! tag_name!]

  def call
    response = account.restapi_client.post(
      endpoint: 'sale/offer-tags',
      params: {
        name: tag_name,
        hidden: false
      }
    )
    response.result
  end
end
