# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Allegro::Tags::Products::Update do
  subject { described_class.call(product: product) }

  let(:product) { create(:redbox_product) }

  let!(:active_auction) { create(:allegro_auction, product: product, end: nil) }
  let!(:inactive_auction) { create(:allegro_auction, product: product, end: 1.year.ago) }
  let!(:different_product_auction) do
    create(:allegro_auction, product: create(:redbox_product), end: 1.year.ago)
  end

  before { allow(Allegro::Offer::OfferTags::UpdateJob).to receive(:perform_async) }

  it 'schedules auction update for every active auction with this product and returns success' do
    expect(Allegro::Offer::OfferTags::UpdateJob).to(
      receive(:perform_async).with(active_auction.id).once
    )
    expect(Allegro::Offer::OfferTags::UpdateJob).not_to(
      receive(:perform_async).with(inactive_auction.id)
    )
    expect(Allegro::Offer::OfferTags::UpdateJob).not_to(
      receive(:perform_async).with(different_product_auction.id)
    )
    expect(subject).to be_success
  end
end
