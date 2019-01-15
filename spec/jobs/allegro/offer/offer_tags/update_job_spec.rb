# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Allegro::Offer::OfferTags::UpdateJob do
  subject { described_class.new.perform(auction.id) }

  let(:update_result) { Result::Success.new }

  before do
    allow(Allegro::Offer::OfferTags::Update).to receive(:call).and_return(update_result)
  end

  context "when auction doesn't exist" do
    let(:auction) { instance_double(Allegro::Auction, id: 0) }

    it 'raises not found exception' do
      expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context 'when auction exists' do
    let(:auction) { create(:allegro_auction) }

    it 'calls Allegro::Offer::OfferTags::Update with auction' do
      expect(Allegro::Offer::OfferTags::Update).to(
        receive(:call).with(auction: auction)
      ).once
      subject
    end
  end
end
