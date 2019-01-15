# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Allegro::Restapi::Tokens::Expire do
  include ActiveSupport::Testing::TimeHelpers

  subject { described_class.call(account: account) }

  let(:account) { create(:allegro_account, expires_at: 1.year.from_now) }
  let(:current_time) { Time.zone.local(2017, 11, 29, 11, 0) }

  before { travel_to current_time }

  after { travel_back }

  it 'updates expires_at to current time' do
    subject
    expect(account.expires_at).to eq current_time
  end
end
