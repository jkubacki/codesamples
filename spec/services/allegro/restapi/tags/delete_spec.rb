# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Allegro::Restapi::Tags::Delete do
  subject { described_class.call(tag: tag) }

  let(:tag) do
    build_stubbed(
      :allegro_tag,
      allegro_id: 'b9f75c79-5961-4b59-bc86-88ac48196a64',
      account: account
    )
  end
  let(:account) { build_stubbed(:allegro_account) }
  let(:result) { Result::Success.new }

  let(:restapi_client) { double }
  let(:allegro_response) { instance_double(Allegro::Restapi::Response, result: result) }

  before do
    allow(account).to receive(:restapi_client).and_return(restapi_client)
    allow(restapi_client).to receive(:delete).and_return(allegro_response)
  end

  it 'calls restapi_client post with proper parameters' do
    expect(restapi_client).to(
      receive(:delete).with(endpoint: 'sale/offer-tags/b9f75c79-5961-4b59-bc86-88ac48196a64')
    ).once
    subject
  end

  it 'returns result from allegro response' do
    expect(subject).to eq result
  end
end
