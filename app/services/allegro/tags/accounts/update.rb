# frozen_string_literal: true

class Allegro::Tags::Accounts::Update < ApplicationService
  attr_private_initialize(%i[account!])

  def call
    sync_tags
      .on_success(&method(:update_offers_tags))
  end

  private

  def sync_tags
    Allegro::Tags::Accounts::Sync.call(account: account)
  end

  def update_offers_tags
    account.auctions.active.order(id: :desc).pluck(:id).each do |auction_id|
      Allegro::Offer::OfferTags::UpdateJob.perform_async(auction_id)
    end
    success
  end
end
