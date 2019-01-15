# frozen_string_literal: true

class Shoper::Product < ApplicationRecord
  belongs_to :product, class_name: 'Redbox::Product'
  belongs_to :account, class_name: 'Shoper::Account'
  has_many :product_images
  has_many :product_categories
  has_many :categories, through: :product_categories

  validates :shoper_id, :product, :account, presence: true
end
