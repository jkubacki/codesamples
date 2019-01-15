# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shoper::ProductImage, type: :model do
  it { is_expected.to belong_to :product }

  it { is_expected.to validate_presence_of :product }
  it { is_expected.to validate_presence_of :image_hash }
  it { is_expected.to validate_presence_of :shoper_id }
end
