# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Allegro::Restapi::Tokens::HandleInvalidTokenResponse do
  subject { described_class.call(response: response, account: account) }

  let(:response) do
    instance_double(HTTParty::Response, code: code, parsed_response: parsed_response)
  end
  let(:account) { build_stubbed(:allegro_account, token: 'access_token') }

  let(:code) { 200 }
  let(:parsed_response) { {} }
  let(:expire_result) { double }

  before do
    allow(Allegro::Restapi::Tokens::ExpireJob).to(
      receive(:perform_async).with(account.id)
    ).and_return(expire_result)
  end

  shared_examples "doesn't expire token" do
    it 'returns success' do
      expect(subject).to be_success
    end

    it "doesn't expire token" do
      expect(Allegro::Restapi::Tokens::ExpireJob).not_to receive(:call)
      subject
    end
  end

  context 'when response code is not 401' do
    let(:code) { 200 }
    let(:parsed_response) { { 'error' => 'invalid_token' } }

    it_behaves_like "doesn't expire token"

    context 'when response code is 401' do
      let(:code) { 401 }

      context 'when error is not invalid token' do
        let(:parsed_response) { { 'error' => 'other error' } }

        it_behaves_like "doesn't expire token"
      end

      context 'when error is invalid token' do
        let(:parsed_response) { { 'error' => 'invalid_token' } }

        it 'schedules expire token job' do
          expect(Allegro::Restapi::Tokens::ExpireJob).to(
            receive(:perform_async).with(account.id)
          ).once
          subject
        end

        it 'returns expire result' do
          expect(subject).to eq expire_result
        end
      end
    end
  end
end
