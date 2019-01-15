# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Allegro::Tags::Delete do
  subject { described_class.call(tag: tag) }

  let(:tag) { build_stubbed(:allegro_tag) }
  let(:restapi_tag_delete_result) { Result::Success.new }

  before do
    allow(Allegro::Restapi::Tags::Delete).to receive(:call).and_return(restapi_tag_delete_result)
    allow(tag).to receive(:destroy!)
  end

  it 'destroys tag record' do
    expect(tag).to receive(:destroy!).once
    subject
  end

  it 'deletes tag in allegro' do
    expect(Allegro::Restapi::Tags::Delete).to receive(:call).with(tag: tag).once
    subject
  end
end
