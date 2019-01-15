# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Allegro::Restapi::Tags::Create do
  subject { described_class.call(account: account, tag_name: 'tag name') }

  let(:account) { build_stubbed(:allegro_account) }

  let(:client) { double }
  let(:allegro_response) { instance_double(Allegro::Restapi::Response, result: result) }
  let(:result) { Result::Success.new }

  before do
    allow(account).to receive(:restapi_client).and_return(client)
    allow(client).to receive(:post).and_return(allegro_response)
  end

  it 'sends post request to allegro api with tag name' do
    expect(client).to receive(:post).with(
      endpoint: 'sale/offer-tags',
      params: {
        name: 'tag name',
        hidden: false
      }
    ).once
    subject
  end

  it 'returns result from allegro response' do
    expect(subject).to eq result
  end
end
