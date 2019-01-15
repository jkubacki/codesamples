# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Allegro::Tags::Create do
  subject { described_class.call(account: account, tag_name: 'tag_name') }

  let(:account) { build_stubbed(:allegro_account) }
  let(:allegro_create_result) { Result::Success.new(data: { 'id' => '999' }) }
  let(:allegro_tag) { build_stubbed(:allegro_tag) }

  before do
    allow(Allegro::Restapi::Tags::Create).to receive(:call).and_return(allegro_create_result)
    allow(Allegro::Tag).to receive(:create!).and_return(allegro_tag)
  end

  it 'creates tag in allegro' do
    expect(Allegro::Restapi::Tags::Create).to(
      receive(:call).with(account: account, tag_name: 'tag_name')
    ).once
    subject
  end

  context 'when allegro create is a success' do
    let(:allegro_create_result) { Result::Success.new(data: { 'id' => '999' }) }

    it 'creates allegro tag' do
      expect(Allegro::Tag).to receive(:create!).with(
        name: 'tag_name',
        account: account,
        allegro_id: '999',
        hidden: false
      ).once
      subject
    end

    it 'returns success with allegro tag record' do
      expect(subject).to be_success
      expect(subject.data).to eq allegro_tag
    end
  end

  context 'when allegro create is a failure' do
    let(:allegro_create_result) { Result::Failure.new }

    it "doesn't create allegro tag" do
      expect(Allegro::Tag).not_to receive(:create!)
      subject
    end

    it 'returns allegro create failure' do
      expect(subject).to eq allegro_create_result
    end
  end
end
