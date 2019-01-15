# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Packaging::Inpost::OrdersController do
  describe 'GET show' do
    subject { get :show, params: { id: order.id } }

    let(:user) { create(:user) }
    let(:order) { create(:combine_order) }

    before do
      sign_in user
      allow(Packaging::Inpost::GetOrdinalNumber).to(
        receive(:call).and_return(Result::Success.new(data: 5))
      )
    end

    include_context 'authorized', Packaging::Inpost::OrdersControllerPolicy, :show?

    it 'gets ordinal number for order' do
      expect(Packaging::Inpost::GetOrdinalNumber).to(
        receive(:call).with(order: order)
      ).once
      subject
    end

    it 'renders show with order and ordinal number' do
      subject
      expect(response).to render_template(:show, locals: { order: order, ordinal_number: 5 })
    end
  end

  describe 'GET index' do
    subject { get :index, params: { section_id: '123' } }

    let(:user) { create(:user) }
    let(:orders) { instance_double(ActiveRecord::Relation, includes: nil) }

    before do
      sign_in user
      allow(Packaging::Inpost::OrdersQuery).to receive(:call).and_return(orders)
    end

    include_context 'authorized', Packaging::Inpost::OrdersControllerPolicy, :index?

    it 'fetches orders from section' do
      expect(Packaging::Inpost::OrdersQuery).to receive(:call).with(section_id: '123').once
      subject
    end

    it 'renders index with orders' do
      subject
      expect(response).to render_template(:index, locals: { orders: orders })
    end
  end
end
