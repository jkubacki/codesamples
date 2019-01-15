# frozen_string_literal: true

class Allegro::Tags::Products::ShouldUpdate < ApplicationService
  attr_private_initialize(%i[product_after_update! before_style_ids! before_ocassion_ids!])

  def call
    success(data: styles_or_ocassions_changed?)
  end

  private

  def styles_or_ocassions_changed?
    product_after_update.style_ids != before_style_ids ||
      product_after_update.ocassion_ids != before_ocassion_ids
  end
end
