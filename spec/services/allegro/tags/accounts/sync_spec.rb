# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Allegro::Tags::Accounts::Sync do
  subject { described_class.call(account: account) }

  let(:account) { create(:allegro_account) }

  let(:create_result) { Result::Success.new }
  let(:delete_result) { Result::Success.new }

  let(:combine_tag_names) { ['tag name'] }

  before do
    allow(Allegro::Tags::Create).to receive(:call).and_return(create_result)
    allow(Allegro::Tags::Delete).to receive(:call).and_return(delete_result)
    allow(Allegro::Tags::AllQuery).to receive(:call).and_return(combine_tag_names)
  end

  context 'without missing tags' do
    before do
      create(:allegro_tag, account: account, name: 'tag name')
    end

    it "doesn't create new allegro tag" do
      expect(Allegro::Tags::Create).not_to receive(:call)
      subject
    end
  end

  context 'with missing tags' do
    it 'creates new tag for missing name' do
      expect(Allegro::Tags::Create).to(
        receive(:call).with(account: account, tag_name: 'tag name')
      ).once
      subject
    end

    context 'when Allegro::Tags::Create fails' do
      let(:create_result) { Result::Failure.new }

      it 'returns create failure' do
        expect(subject).to eq create_result
      end
    end
  end

  context 'without not matching tags' do
    it "doesn't delete allegro tag" do
      expect(Allegro::Tags::Delete).not_to receive(:call)
      subject
    end
  end

  context 'with not matching tags' do
    let(:not_matching_tag) { create(:allegro_tag, account: account, name: 'not matching tag') }

    it 'deletes not matching allegro tag' do
      expect(Allegro::Tags::Delete).to(
        receive(:call).with(tag: not_matching_tag)
      ).once
      subject
    end
  end
end
