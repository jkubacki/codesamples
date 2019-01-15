# frozen_string_literal: true

class Packaging::Inpost::ValidationsController < ApplicationController
  def index
    orders = Packaging::Inpost::OrdersQuery.call(section_id: section_id)
    result = ::Inpost::Points::ValidateOrders.call(orders: orders)
    handle_validation_result(result)
  end

  private

  def section_id
    @section_id ||= params[:section_id]
  end

  def handle_validation_result(result)
    if result.failure?
      render_validation_failure(result)
    elsif result.data.empty?
      redirect_to_packing_orders
    else
      render :index, locals: { validations: result.data }
    end
  end

  def render_validation_failure(result)
    flash[:alert] = "Błąd walidacji paczkomatów: #{result.message}"
    render html: '', layout: 'application'
  end

  def redirect_to_packing_orders
    redirect_to(
      packaging_inpost_orders_path(section_id: section_id),
      notice: 'Poprawne paczkomaty w zamówieniach'
    )
  end
end
