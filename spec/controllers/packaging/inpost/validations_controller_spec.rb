# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Packaging::Inpost::ValidationsController do
  describe 'GET index' do
    subject { get :index, params: { section_id: 1 } }

    let(:user) { create(:user) }
    let(:orders) { [double] }

    before do
      sign_in user
      allow(Packaging::Inpost::OrdersQuery).to receive(:call).and_return(orders)
      allow(Inpost::Points::ValidateOrders).to(
        receive(:call).with(orders: orders).and_return(validate_result)
      )
    end

    include_context 'authorized', Packaging::Inpost::ValidationsControllerPolicy, :index?

    context 'when validate is a failure' do
      let(:validate_result) { Result::Failure.new(message: 'message') }

      it 'renders empty html page with application layout and failure message in alert flash' do
        subject
        expect(response).to render_with_layout('application')
        expect(response.body).to eq ''
        expect(flash[:alert]).to eq 'Błąd walidacji paczkomatów: message'
      end
    end

    context 'when validate is a success' do
      let(:validate_result) { Result::Success.new(data: validation_data) }

      context 'when success data is empty' do
        let(:validation_data) { [] }

        it 'redirects to packaging_inpost_orders_path with section id and notice' do
          subject
          expect(response).to redirect_to(packaging_inpost_orders_path(section_id: 1))
          expect(flash[:notice]).to eq 'Poprawne paczkomaty w zamówieniach'
        end
      end

      context 'when success data is not empty' do
        let(:validation_data) { { 1 => 'invalid' } }

        it 'renders index with validation data' do
          subject
          expect(response).to render_template(:index, locals: { validations: validation_data })
        end
      end
    end
  end
end
