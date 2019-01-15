# frozen_string_literal: true

class Allegro::Restapi::Tags::Delete < ApplicationService
  attr_private_initialize %i[tag!]

  def call
    response = client.delete(endpoint: "sale/offer-tags/#{tag.allegro_id}")
    response.result
  end

  private

  def client
    tag.account.restapi_client
  end
end
