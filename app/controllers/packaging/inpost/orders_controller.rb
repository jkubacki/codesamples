# frozen_string_literal: true

class Packaging::Inpost::OrdersController < ApplicationController
  def index
    orders =
      Packaging::Inpost::OrdersQuery
      .call(section_id: params[:section_id])
      .includes(:inpost_shipment, :shipment_address)
    render :index, locals: { orders: orders }
  end

  def show
    order = Combine::Order.find(params[:id])
    ordinal_number = Packaging::Inpost::GetOrdinalNumber.call(order: order).data
    render :show, locals: { order: order, ordinal_number: ordinal_number }
  end
end
