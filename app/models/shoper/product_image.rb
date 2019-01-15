# frozen_string_literal: true

class Shoper::ProductImage < ApplicationRecord
  belongs_to :product

  validates :product, :image_hash, :shoper_id, presence: true
end
