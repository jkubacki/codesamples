# frozen_string_literal: true

class Allegro::Offer::OfferTags::UpdateJob < ApplicationJob
  include Sidekiq::Worker
  sidekiq_options queue: 'allegro-auction-tags'

  def perform(auction_id)
    auction = Allegro::Auction.find(auction_id)
    raise_on_failure Allegro::Offer::OfferTags::Update.call(auction: auction)
  end
end
