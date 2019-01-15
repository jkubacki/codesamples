# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Allegro::Tags::Accounts::Update do
  subject { described_class.call(account: account) }

  let(:account) { create(:allegro_account) }
  let(:sync_result) { Result::Failure.new }

  before do
    allow(Allegro::Tags::Accounts::Sync).to receive(:call).and_return(sync_result)
    allow(Allegro::Offer::OfferTags::UpdateJob).to receive(:perform_async)
  end

  it 'synchs tags for an account' do
    expect(Allegro::Tags::Accounts::Sync).to receive(:call).with(account: account).once
    subject
  end

  context 'when sync is a failure' do
    let(:sync_result) { Result::Failure.new }

    it 'returns sync failure' do
      expect(subject).to eq sync_result
    end
  end

  context 'when sync is a success' do
    let(:sync_result) { Result::Success.new }

    context 'when auction not from account' do
      before { create(:allegro_auction, account: create(:allegro_account)) }

      it "doesn't enqueue update job" do
        expect(Allegro::Offer::OfferTags::UpdateJob).not_to receive(:perform_async)
        subject
      end
    end

    context 'when auction from account' do
      context 'when auction inactive' do
        before { create(:allegro_auction, account: account, end: 1.year.ago) }

        it "doesn't enqueue update job" do
          expect(Allegro::Offer::OfferTags::UpdateJob).not_to receive(:perform_async)
          subject
        end
      end

      context 'when auction active' do
        let!(:auction) { create(:allegro_auction, account: account, end: nil) }

        it 'enqueues update job' do
          expect(Allegro::Offer::OfferTags::UpdateJob).to(
            receive(:perform_async).with(auction.id)
          ).once
          subject
        end
      end
    end
  end
end
