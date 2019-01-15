# frozen_string_literal: true

class Shoper::Categories::HasActiveProductsQuery < ApplicationQuery
  attr_private_initialize(%i[shoper_category!])

  def call
    Shoper::ProductCategory
      .joins(:product)
      .where(shoper_products: { active: true })
      .where(category: category_with_subcategories)
      .any?
  end

  private

  def category_with_subcategories
    Shoper::Category
      .where(account: shoper_category.account)
      .where('redbox_category_id LIKE ?', "#{shoper_category.redbox_category_id}%")
  end
end
