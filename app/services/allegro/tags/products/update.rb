# frozen_string_literal: true

class Allegro::Tags::Products::Update < ApplicationService
  attr_private_initialize(%i[product!])

  def call
    product.auctions.active.pluck(:id).each do |auction_id|
      Allegro::Offer::OfferTags::UpdateJob.perform_async(auction_id)
    end
    success
  end
end
